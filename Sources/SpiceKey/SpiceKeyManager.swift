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
import os

typealias SpiceKeyID = UInt32

final class SpiceKeyManager: Sendable {
    public static let shared = SpiceKeyManager()

    private let signature = OSType("SpiceKey")
    private let protectedHotKeyEventHandler = OSAllocatedUnfairLock<EventHandlerRef?>(uncheckedState: nil)
    private let protectedMonitors = OSAllocatedUnfairLock<[Any?]>(uncheckedState: [])
    private let protectedNotifyTask = OSAllocatedUnfairLock<Task<Void, Never>?>(initialState: nil)
    private let protectedInvoked = OSAllocatedUnfairLock<Bool>(initialState: false)
    private let protectedTimerTask = OSAllocatedUnfairLock<Task<Void, Never>?>(initialState: nil)
    private let protectedSpiceKeys = OSAllocatedUnfairLock<[SpiceKeyID : SpiceKey]>(initialState: [:])
    private let protectedEventHotKeys = OSAllocatedUnfairLock<[SpiceKeyID : EventHotKeyRef]>(uncheckedState: [:])

    private init() {}

    private func startMonitoring() {
        guard protectedMonitors.withLockUnchecked({ $0.isEmpty }) else { return }
        let hotKeySpecs: [EventTypeSpec] = [
            EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed)),
            EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyReleased)),
        ]
        let hotKeyHandleNegotiator: EventHandlerUPP = { _, event, _ in
            SpiceKeyManager.shared.hotKeyHandleEvent(event)
        }
        var hotKeyEventHandler = protectedHotKeyEventHandler.withLockUnchecked(\.self)
        InstallEventHandler(
            GetEventDispatcherTarget(),
            hotKeyHandleNegotiator,
            hotKeySpecs.count,
            hotKeySpecs,
            nil,
            &hotKeyEventHandler
        )
        protectedMonitors.withLockUnchecked { monitors in
            monitors.append(NSEvent.addLocalMonitorForEvents(matching: .flagsChanged, handler: { [weak self] (event) -> NSEvent? in
                self?.modFlagHandleEvent(event)
                return event
            }))
            monitors.append(NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: { [weak self] (event) in
                self?.modFlagHandleEvent(event)
            }))
        }
        protectedNotifyTask.withLock { task in
            task = Task {
                for await _ in NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification).values {
                    stopMonitoring()
                }
            }
        }
    }

    private func stopMonitoring() {
        protectedHotKeyEventHandler.withLockUnchecked { hotKeyEventHandler in
            if hotKeyEventHandler != nil {
                RemoveEventHandler(hotKeyEventHandler)
                hotKeyEventHandler = nil
            }
        }
        protectedSpiceKeys.withLock { spiceKeys in
            spiceKeys.values.forEach { unregister($0) }
            spiceKeys.removeAll()
        }
        protectedMonitors.withLockUnchecked { monitors in
            monitors.forEach { NSEvent.removeMonitor($0!) }
            monitors.removeAll()
        }
        protectedNotifyTask.withLock { task in
            task?.cancel()
            task = nil
        }
    }
    
    func generateID() -> SpiceKeyID {
        let spiceKeysKeys = protectedSpiceKeys.withLock { $0.keys }
        var r: SpiceKeyID = .zero
        repeat {
            r = SpiceKeyID.random(in: 10000 ..< 100000)
        } while spiceKeysKeys.contains(r)
        return r
    }
    
    func register(_ spiceKey: SpiceKey) {
        let spiceKeys = protectedSpiceKeys.withLock(\.self)
        let isContained = spiceKeys.contains { keyData in
            guard keyData.key != spiceKey.id else { return true }
            let exist = keyData.value
            return if let keyCombA = exist.keyCombination, let keyCombB = spiceKey.keyCombination, keyCombA == keyCombB {
                true
            } else if exist.modifierFlags == spiceKey.modifierFlags {
                (exist.isBothSide && spiceKey.isBothSide) || (exist.interval > .zero && spiceKey.interval > .zero)
            } else {
                false
            }
        }
        guard !isContained else { return }
        protectedSpiceKeys.withLock { spiceKeys in
            spiceKeys[spiceKey.id] = spiceKey
        }
        startMonitoring()
        guard !spiceKey.isBothSide && spiceKey.interval == .zero else { return }
        var eventHotKey: EventHotKeyRef?
        let error = RegisterEventHotKey(
            spiceKey.keyCombination!.key.keyCode32,
            spiceKey.keyCombination!.modifierFlags.flags32,
            EventHotKeyID(signature: signature, id: spiceKey.id),
            GetEventDispatcherTarget(),
            .zero,
            &eventHotKey
        )
        guard error == noErr else { return }
        protectedEventHotKeys.withLockUnchecked { eventHotKeys in
            eventHotKeys[spiceKey.id] = eventHotKey
        }
    }
    
    func unregister(_ spiceKey: SpiceKey) {
        let spiceKeys = protectedSpiceKeys.withLock(\.self)
        let isContained = spiceKeys.values.contains { $0.id == spiceKey.id }
        guard isContained else { return }
        if !spiceKey.isBothSide && spiceKey.interval == .zero {
            protectedEventHotKeys.withLockUnchecked { eventHotKeys in
                UnregisterEventHotKey(eventHotKeys[spiceKey.id])
                eventHotKeys.removeValue(forKey: spiceKey.id)
            }
        }
        let isEmpty = protectedSpiceKeys.withLock { spiceKeys in
            spiceKeys.removeValue(forKey: spiceKey.id)
            return spiceKeys.isEmpty
        }
        if isEmpty { stopMonitoring() }
    }
    
    func hotKeyHandleEvent(_ event: EventRef?) -> OSStatus {
        if event == nil { return OSStatus(eventNotHandledErr) }
        var hotKeyID = EventHotKeyID()
        let error = GetEventParameter(
            event,
            EventParamName(kEventParamDirectObject),
            EventParamType(typeEventHotKeyID),
            nil,
            MemoryLayout<EventHotKeyID>.size,
            nil,
            &hotKeyID
        )
        guard error == noErr else { return error }
        let spiceKeys = protectedSpiceKeys.withLock(\.self)
        guard hotKeyID.signature == signature,
              let spiceKey = spiceKeys.values.first(where: { $0.id == hotKeyID.id }) else {
            return OSStatus(eventNotHandledErr)
        }
        switch GetEventKind(event) {
        case OSType(kEventHotKeyPressed):
            guard let handler = spiceKey.keyDownHandler else { break }
            Task { await handler() }
            return noErr
        case OSType(kEventHotKeyReleased):
            guard let handler = spiceKey.keyUpHandler else { break }
            Task { await handler() }
            return noErr
        default:
            break
        }
        return OSStatus(eventNotHandledErr)
    }
    
    private func invokeBothSideSpiceKey(_ flags: ModifierFlags) {
        let spiceKeys = protectedSpiceKeys.withLock(\.self)
        guard let spiceKey = spiceKeys.values.first(where: { $0.isBothSide && $0.modifierFlags == flags }) else {
            return
        }
        protectedInvoked.withLock { $0 = true }
        protectedSpiceKeys.withLock { spiceKeys in
            spiceKeys[spiceKey.id]?.invoked = true
        }
        Task { await spiceKey.bothModifierKeysPressHandler?() }
    }
    
    private func invokeLongPressSpiceKey(_ flags: ModifierFlags) {
        let spiceKeys = protectedSpiceKeys.withLock(\.self)
        guard let spiceKey = spiceKeys.values.first(where: { $0.interval > .zero && $0.modifierFlags == flags }) else {
            return
        }
        protectedTimerTask.withLock { task in
            task = Task {
                try? await Task.sleep(for: .seconds(spiceKey.interval))
                protectedInvoked.withLock { $0 = true }
                protectedSpiceKeys.withLock { $0[spiceKey.id]?.invoked = true }
                await spiceKey.modifierKeysLongPressHandler?()
            }
        }
    }

    private func invokeReleaseKey() {
        protectedSpiceKeys.withLock { spiceKeys in
            spiceKeys.forEach { id, spiceKey in
                guard spiceKey.invoked else { return }
                spiceKeys[id]?.invoked = false
                Task { await spiceKey.releaseKeyHandler?() }
            }
        }
    }
    
    func modFlagHandleEvent(_ event: NSEvent) {
        protectedTimerTask.withLock { task in
            task?.cancel()
            task = nil
        }
        let nsFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        let flags = ModifierFlags(flags: nsFlags)
        guard flags != .empty else {
            protectedInvoked.withLock { $0 = false }
            invokeReleaseKey()
            return
        }
        guard protectedInvoked.withLock(\.self) == false else { return }
        let bothFlags = ModifierBothFlags(modifierFlags: event.modifierFlags)
        if bothFlags.isBoth {
            invokeBothSideSpiceKey(flags)
        } else { // Long Press
            invokeLongPressSpiceKey(flags)
        }
    }
}
