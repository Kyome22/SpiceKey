/*
 SpiceKeyManager.swift
 SpiceKey

 Created by Takuto Nakamura on 2019/03/03.
 Copyright © 2019 Takuto Nakamura. All rights reserved.
*/

import AppKit.NSEvent
import Carbon
import Carbon.HIToolbox.Events
import Combine

typealias SpiceKeyID = UInt32

final class SpiceKeyManager {
    public static let shared = SpiceKeyManager()
    internal var spiceKeys = [SpiceKeyID : SpiceKey]()
    private var hotKeyEventHandlerRef: EventHandlerRef? = nil
    private let signature = OSType("SpiceKey")
    private var monitors = [Any?]()
    private var notifyCancellable: AnyCancellable?
    private var invoked: Bool = false
    private var timer: Timer? = nil
    
    private init() {
        let hotKeySpecs: [EventTypeSpec] = [
            EventTypeSpec(eventClass: OSType(kEventClassKeyboard),
                          eventKind: UInt32(kEventHotKeyPressed)),
            EventTypeSpec(eventClass: OSType(kEventClassKeyboard),
                          eventKind: UInt32(kEventHotKeyReleased))
        ]
        InstallEventHandler(GetEventDispatcherTarget(),
                            hotKeyHandleNegotiator,
                            hotKeySpecs.count,
                            hotKeySpecs,
                            nil,
                            &hotKeyEventHandlerRef)
        monitors.append(NSEvent.addLocalMonitorForEvents(matching: .flagsChanged, handler: { (event) -> NSEvent? in
            SpiceKeyManager.shared.modFlagHandleEvent(event)
            return event
        }))
        monitors.append(NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: { (event) in
            SpiceKeyManager.shared.modFlagHandleEvent(event)
        }))
        
        notifyCancellable = NotificationCenter.default
            .publisher(for: NSApplication.willTerminateNotification)
            .sink { [weak self] _ in
                self?.deinitialize()
            }
    }

    private func deinitialize() {
        if hotKeyEventHandlerRef != nil {
            RemoveEventHandler(hotKeyEventHandlerRef)
        }
        removeAllSpiceKey()
        removeMonitors()
    }
    
    func removeAllSpiceKey() {
        spiceKeys.values.forEach { (spiceKey) in
            unregister(spiceKey)
        }
    }

    func removeMonitors() {
        monitors.forEach { (monitor) in
            NSEvent.removeMonitor(monitor!)
        }
        monitors.removeAll()
    }
    
    func generateID() -> SpiceKeyID {
        var r: SpiceKeyID = 0
        repeat {
            r = SpiceKeyID.random(in: 10000 ..< 100000)
        } while spiceKeys.keys.contains(r)
        return r
    }
    
    func register(_ spiceKey: SpiceKey) {
        guard !spiceKeys.contains(where: { (keyData) -> Bool in
            if keyData.key == spiceKey.id {
                return true
            }
            let exist = keyData.value
            if let keyCombA = exist.keyCombination, let keyCombB = spiceKey.keyCombination, keyCombA == keyCombB {
                return true
            } else if exist.modifierFlags == spiceKey.modifierFlags {
                return (exist.isBothSide && spiceKey.isBothSide) || (exist.interval > 0.0 && spiceKey.interval > 0.0)
            }
            return false
        }) else {
            return
        }
        spiceKeys[spiceKey.id] = spiceKey
        guard !spiceKey.isBothSide && spiceKey.interval == 0.0 else { return }
        let keyCode32 = spiceKey.keyCombination!.key.keyCode32
        let flags32 = spiceKey.keyCombination!.modifierFlags.flags32
        let hotKeyID = EventHotKeyID(signature: signature, id: spiceKey.id)
        var eventHotKey: EventHotKeyRef? = nil
        let error = RegisterEventHotKey(keyCode32, flags32, hotKeyID,
                                        GetEventDispatcherTarget(),
                                        0, &eventHotKey)
        guard error == noErr else { return }
        spiceKey.eventHotKey = eventHotKey
    }
    
    func unregister(_ spiceKey: SpiceKey) {
        guard spiceKeys.values.contains(where: { (spiceKey_) -> Bool in
            return spiceKey.id == spiceKey_.id
        }) else { return }
        if !spiceKey.isBothSide && spiceKey.interval == 0.0 {
            UnregisterEventHotKey(spiceKey.eventHotKey)
        }
        spiceKeys.removeValue(forKey: spiceKey.id)
    }
    
    func hotKeyHandleEvent(_ event: EventRef?) -> OSStatus {
        if event == nil { return OSStatus(eventNotHandledErr) }
        var hotKeyID = EventHotKeyID()
        let error = GetEventParameter(event,
                                      EventParamName(kEventParamDirectObject),
                                      EventParamType(typeEventHotKeyID),
                                      nil,
                                      MemoryLayout<EventHotKeyID>.size,
                                      nil,
                                      &hotKeyID)
        if error != noErr { return error }
        guard hotKeyID.signature == signature else {
            return OSStatus(eventNotHandledErr)
        }
        guard let spiceKey = spiceKeys.values.first(where: { (spiceKey) -> Bool in
            return spiceKey.id == hotKeyID.id
        }) else {
            return OSStatus(eventNotHandledErr)
        }
        switch GetEventKind(event) {
        case OSType(kEventHotKeyPressed):
            if let handler = spiceKey.keyDownHandler {
                Task {
                    await handler()
                }
                return noErr
            }
        case OSType(kEventHotKeyReleased):
            if let handler = spiceKey.keyUpHandler {
                Task {
                    await handler()
                }
                return noErr
            }
        default:
            break
        }
        return OSStatus(eventNotHandledErr)
    }
    
    private func invokeBothSideSpiceKey(_ flags: ModifierFlags) {
        guard let bothSideSpiceKey = spiceKeys.values.first(where: { (spiceKey) -> Bool in
            return spiceKey.isBothSide && spiceKey.modifierFlags == flags
        }) else { return }
        invoked = true
        bothSideSpiceKey.invoked = true
        Task {
            await bothSideSpiceKey.bothModifierKeysPressHandler?()
        }
    }
    
    private func invokeLongPressSpiceKey(_ flags: ModifierFlags) {
        guard let longPressSpiceKey = spiceKeys.values.first(where: { (spiceKey) -> Bool in
            return 0.0 < spiceKey.interval && spiceKey.modifierFlags == flags
        }) else { return }
        let interval = longPressSpiceKey.interval
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.invoked = true
            longPressSpiceKey.invoked = true
            Task {
                await longPressSpiceKey.modifierKeysLongPressHandler?()
            }
        }
    }

    private func invokeReleaseKey() {
        spiceKeys.values.forEach { (spiceKey) in
            guard spiceKey.invoked else { return }
            spiceKey.invoked = false
            Task {
                await spiceKey.releaseKeyHandler?()
            }
        }
    }
    
    func modFlagHandleEvent(_ event: NSEvent) {
        timer?.invalidate()
        let nsFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        let flags = ModifierFlags(flags: nsFlags)
        guard flags != .empty else {
            invoked = false
            invokeReleaseKey()
            return
        }
        guard !invoked else { return }
        let bothFlags = ModifierBothFlags(modifierFlags: event.modifierFlags)
        if bothFlags.isBoth {
            invokeBothSideSpiceKey(flags)
        } else { // Long Press
            invokeLongPressSpiceKey(flags)
        }
    }
}

private func hotKeyHandleNegotiator(
    eventHandlerCall: EventHandlerCallRef?,
    event: EventRef?,
    userData: UnsafeMutableRawPointer?
) -> OSStatus {
    SpiceKeyManager.shared.hotKeyHandleEvent(event)
}
