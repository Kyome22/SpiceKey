//
//  SpiceKeyManager.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import AppKit.NSEvent
import Carbon
import Carbon.HIToolbox.Events

typealias SpiceKeyID = UInt32

final class SpiceKeyManager {
    
    public static let shared = SpiceKeyManager()
    internal var spiceKeys = [SpiceKeyID : SpiceKey]()
    private let signature = UTGetOSTypeFromString("SpiceKey" as CFString)
    private var monitors = [Any?]()
    private var keyFlags = [ModifierKey : Bool]()
    private var modifierFlags: ModifierFlags = .empty
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
                            hotKeySpecs, nil, nil)
        monitors.append(NSEvent.addLocalMonitorForEvents(matching: .flagsChanged, handler: { (event) -> NSEvent? in
            SpiceKeyManager.shared.modFlagHandleEvent(event)
            return event
        }))
        monitors.append(NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: { (event) in
            SpiceKeyManager.shared.modFlagHandleEvent(event)
        }))
        
        NotificationCenter.default.addObserver(
            forName: NSApplication.willTerminateNotification,
            object: nil, queue: nil) { [weak self] _ in
                self?.removeAllSpiceKey()
                self?.removeMonitors()
        }
    }
    
    deinit {
        removeAllSpiceKey()
        removeMonitors()
    }
    
    func removeMonitors() {
        monitors.forEach { (monitor) in
            NSEvent.removeMonitor(monitor!)
        }
        monitors.removeAll()
    }
    
    func removeAllSpiceKey() {
        spiceKeys.values.forEach { (spiceKey) in
            unregister(spiceKey)
        }
    }
    
    func generateID() -> SpiceKeyID {
        var r: SpiceKeyID = 0
        repeat {
            r = SpiceKeyID.random(in: 10000 ..< 100000)
        } while spiceKeys.keys.contains(r)
        return r
    }
    
    func register(_ spiceKey: SpiceKey) {
        if spiceKeys.contains(where: { (keyData) -> Bool in
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
        }) {
            return
        }
        spiceKeys[spiceKey.id] = spiceKey
        if !spiceKey.isBothSide && spiceKey.interval == 0.0 {
            let keyCode32 = spiceKey.keyCombination!.key.keyCode32
            let flags32 = spiceKey.keyCombination!.modifierFlags.flags32
            let hotKeyID = EventHotKeyID(signature: signature, id: spiceKey.id)
            var eventHotKey: EventHotKeyRef? = nil
            let error = RegisterEventHotKey(keyCode32, flags32, hotKeyID,
                                            GetEventDispatcherTarget(),
                                            0, &eventHotKey)
            if error != noErr { return }
            spiceKey.eventHotKey = eventHotKey
        }
    }
    
    func unregister(_ spiceKey: SpiceKey) {
        if !spiceKeys.values.contains(where: { (spiceKey_) -> Bool in
            return spiceKey.id == spiceKey_.id
        }) {
            return
        }
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
        if hotKeyID.signature == signature {
            if let spiceKey = spiceKeys.values.first(where: { (spiceKey) -> Bool in
                return spiceKey.id == hotKeyID.id
            }) {
                switch GetEventKind(event) {
                case OSType(kEventHotKeyPressed):
                    if let handler = spiceKey.keyDownHandler {
                        handler()
                        return noErr
                    }
                case OSType(kEventHotKeyReleased):
                    if let handler = spiceKey.keyUpHandler {
                        handler()
                        return noErr
                    }
                default:
                    break
                }
                
            }
        }
        return OSStatus(eventNotHandledErr)
    }
    
    private func invokeBothSideSpiceKey(_ flags: ModifierFlags) {
        if let bothSideSpiceKey = spiceKeys.values.first(where: { (spiceKey) -> Bool in
            return spiceKey.isBothSide && spiceKey.modifierFlags == flags
        }) {
            bothSideSpiceKey.bothSideModifierKeysPressHandler?()
        }
    }
    
    private func invokeLongPressSpiceKey(_ flags: ModifierFlags) {
        if let longPressSpiceKey = spiceKeys.values.first(where: { (spiceKey) -> Bool in
            return 0.0 < spiceKey.interval && spiceKey.modifierFlags == flags
        }) {
            timer = Timer.scheduledTimer(withTimeInterval: longPressSpiceKey.interval, repeats: false, block: { _ in
                DispatchQueue.main.async {
                    longPressSpiceKey.modifierKeyLongPressHandler?()
                }
            })
        }
    }
    
    func modFlagHandleEvent(_ event: NSEvent) {
        timer?.invalidate()

        let nsFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        let flags = ModifierFlags(flags: nsFlags)
        if flags == .empty {
            keyFlags.removeAll()
            return
        }

        let modifierKey = ModifierKey(keyCode: event.keyCode)
        if modifierKey != nil {
            keyFlags[modifierKey!] = !(keyFlags[modifierKey!] ?? false)
        }
        
        // press both side
        switch flags {
        case .ctrl:
            if keyFlags[.leftControl] == true && keyFlags[.rightControl] == true {
                invokeBothSideSpiceKey(flags)
            } else if keyFlags[.leftControl] == true || keyFlags[.rightControl] == true {
                invokeLongPressSpiceKey(flags)
            }
        case .opt:
            if keyFlags[.leftOption] == true && keyFlags[.rightOption] == true {
                invokeBothSideSpiceKey(flags)
            } else if keyFlags[.leftOption] == true || keyFlags[.rightOption] == true {
                invokeLongPressSpiceKey(flags)
            }
        case .sft:
            if keyFlags[.leftShift] == true && keyFlags[.rightShift] == true {
                invokeBothSideSpiceKey(flags)
            } else if keyFlags[.leftShift] == true || keyFlags[.rightShift] == true {
                invokeLongPressSpiceKey(flags)
            }
        case .cmd:
            if keyFlags[.leftCommand] == true && keyFlags[.rightCommand] == true {
                invokeBothSideSpiceKey(flags)
            } else if keyFlags[.leftCommand] == true || keyFlags[.rightCommand] == true {
                invokeLongPressSpiceKey(flags)
            }
        default: break
        }
    }
    
}

private func hotKeyHandleNegotiator(eventHandlerCall: EventHandlerCallRef?,
                                    event: EventRef?,
                                    userData: UnsafeMutableRawPointer?) -> OSStatus {
    return SpiceKeyManager.shared.hotKeyHandleEvent(event)
}
