//
//  SpiceKeyManager.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import AppKit
import Carbon

private let LEFT_CONTROL:  Int64 = 0x3B
private let RIGHT_CONTROL: Int64 = 0x3E
private let LEFT_OPTION:   Int64 = 0x3A
private let RIGHT_OPTION:  Int64 = 0x3D
private let LEFT_SHIFT:    Int64 = 0x38
private let RIGHT_SHIFT:   Int64 = 0x3C
private let LEFT_COMMAND:  Int64 = 0x37
private let RIGHT_COMMAND: Int64 = 0x36

final class SpiceKeyManager {
    
    public static let shared = SpiceKeyManager()
    internal var spiceKeys = [UUID : SpiceKey]()
    private let signature = UTGetOSTypeFromString("SpiceKey" as CFString)
    private var count: UInt32 = 0
    private var keyFlag: (left: Bool, right: Bool) = (false, false)
    private var modifierFlags: ModifierFlags = .empty
    private var workItem: DispatchWorkItem? = nil
    
    private init() {
        let eventSpecs: [EventTypeSpec] = [
            EventTypeSpec(eventClass: OSType(kEventClassKeyboard),
                          eventKind: OSType(kEventHotKeyPressed)),
            EventTypeSpec(eventClass: OSType(kEventClassKeyboard),
                          eventKind: OSType(kEventHotKeyReleased))
        ]
        InstallEventHandler(GetEventDispatcherTarget(),
                            eventHandleNegotiator,
                            2, eventSpecs, nil, nil)
        
        // event observation
        if let event = CGEvent.tapCreate(tap: CGEventTapLocation.cghidEventTap,
                                         place: CGEventTapPlacement.headInsertEventTap,
                                         options: CGEventTapOptions.listenOnly,
                                         eventsOfInterest: CGEventMask(1 << CGEventType.flagsChanged.rawValue),
                                         callback: modifiersEventHandleNegotiator,
                                         userInfo: nil) {
            let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, event, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, CFRunLoopMode.commonModes)
            CGEvent.tapEnable(tap: event, enable: true)
        } else {
            Swift.print("Failed to initialize SpiceKeyManager")
        }
    }
    
    deinit {
        // (๑╹ω╹๑ )??
    }
    
    func register(_ spiceKey: SpiceKey) {
        if spiceKeys.contains(where: { (keyData) -> Bool in
            if keyData.key == spiceKey.uuid {
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
        count += 1
        spiceKeys[spiceKey.uuid] = spiceKey
        
        if !spiceKey.isBothSide && spiceKey.interval == 0.0 {
            let keyCode32 = spiceKey.keyCombination!.key.keyCode32
            let flags32 = spiceKey.keyCombination!.modifierFlags.flags32
            let hotKeyID = EventHotKeyID(signature: signature, id: count)
            var eventHotKey: EventHotKeyRef? = nil
            let error = RegisterEventHotKey(keyCode32, flags32, hotKeyID,
                                            GetEventDispatcherTarget(),
                                            0, &eventHotKey)
            if error != noErr {
                return
            }
            spiceKey.setting(eventHotKey!, count)
        }
    }
    
    func unregister(_ spiceKey: SpiceKey) {
        if !spiceKeys.values.contains(where: { (spiceKey_) -> Bool in
            return spiceKey.identifier == spiceKey_.identifier
        }) {
            return
        }
        if !spiceKey.isBothSide && spiceKey.interval == 0.0 {
            UnregisterEventHotKey(spiceKey.eventHotKey)
        }
        spiceKeys.removeValue(forKey: spiceKey.uuid)
    }
    
    func handleEvent(_ event: EventRef?) -> OSStatus {
        if event == nil {
            return OSStatus(eventNotHandledErr)
        }
        var hotKeyID = EventHotKeyID()
        let error = GetEventParameter(event,
                                      EventParamName(kEventParamDirectObject),
                                      EventParamName(typeEventHotKeyID),
                                      nil,
                                      MemoryLayout<EventHotKeyID>.size,
                                      nil,
                                      &hotKeyID)
        if error != noErr {
            return error
        }
        if hotKeyID.signature == signature {
            if let spiceKey = spiceKeys.values.filter({ (spiceKey) -> Bool in
                return spiceKey.identifier == hotKeyID.id
            }).first {
                switch GetEventKind(event) {
                case UInt32(kEventHotKeyPressed):
                    if let handler = spiceKey.keyDownHandler {
                        handler()
                        return noErr
                    }
                case UInt32(kEventHotKeyReleased):
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
    
    private func checkFlags(_ event: CGEvent) -> (ctr: Bool, opt: Bool, sft: Bool, cmd: Bool) {
        let ctr = event.flags.contains(CGEventFlags.maskControl)
        let opt = event.flags.contains(CGEventFlags.maskAlternate)
        let sft = event.flags.contains(CGEventFlags.maskShift)
        let cmd = event.flags.contains(CGEventFlags.maskCommand)
        let ctr_ = ctr && !(opt || sft || cmd)
        let opt_ = opt && !(ctr || sft || cmd)
        let sft_ = sft && !(ctr || opt || cmd)
        let cmd_ = cmd && !(ctr || opt || sft)
        return (ctr_, opt_, sft_, cmd_)
    }
    
    func catchModifersEvent(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        // both side
        let keyCode = event.getIntegerValueField(CGEventField.keyboardEventKeycode)
        let flag = checkFlags(event)
        if flag.ctr || flag.opt || flag.sft || flag.cmd {
            var modifierFlag: ModifierFlag!
            if flag.ctr {
                modifierFlag = ModifierFlag.control
                if keyCode == LEFT_CONTROL { keyFlag.left = !keyFlag.left }
                if keyCode == RIGHT_CONTROL { keyFlag.right = !keyFlag.right }
            }
            if flag.opt {
                modifierFlag = ModifierFlag.option
                if keyCode == LEFT_OPTION { keyFlag.left = !keyFlag.left }
                if keyCode == RIGHT_OPTION { keyFlag.right = !keyFlag.right }
            }
            if flag.sft {
                modifierFlag = ModifierFlag.shift
                if keyCode == LEFT_SHIFT { keyFlag.left = !keyFlag.left }
                if keyCode == RIGHT_SHIFT { keyFlag.right = !keyFlag.right }
            }
            if flag.cmd {
                modifierFlag = ModifierFlag.command
                if keyCode == LEFT_COMMAND { keyFlag.left = !keyFlag.left }
                if keyCode == RIGHT_COMMAND { keyFlag.right = !keyFlag.right }
            }
            
            if keyFlag.left && keyFlag.right {
                let bothSideSpiceKeys = spiceKeys.values.filter { (spiceKey) -> Bool in
                    return spiceKey.isBothSide && spiceKey.modifierFlags! == modifierFlag.flags
                }
                bothSideSpiceKeys.first?.bothSideModifierKeysPressHandler!()
            }
        } else {
            keyFlag = (false, false)
        }
        
        // long tap
        workItem?.cancel()
        let modifierFlags = ModifierFlags(control: event.flags.contains(CGEventFlags.maskControl),
                                          option:  event.flags.contains(CGEventFlags.maskAlternate),
                                          shift:   event.flags.contains(CGEventFlags.maskShift),
                                          command: event.flags.contains(CGEventFlags.maskCommand))
        let longPressSpiceKeys = spiceKeys.values.filter { (spiceKey) -> Bool in
            return spiceKey.interval > 0.0 && spiceKey.modifierFlags! == modifierFlags
        }
        if let spiceKey = longPressSpiceKeys.first {
            workItem = DispatchWorkItem(block: {
                spiceKey.modifierKeyLongPressHandler!()
            })
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + spiceKey.interval, execute: workItem!)
        }
        return Unmanaged.passRetained(event)
    }
    
}

private func eventHandleNegotiator(eventHandlerCall: EventHandlerCallRef?,
                                   event: EventRef?,
                                   userData: UnsafeMutableRawPointer?) -> OSStatus {
    return SpiceKeyManager.shared.handleEvent(event)
}

private func modifiersEventHandleNegotiator(proxy: CGEventTapProxy,
                                            type: CGEventType,
                                            event: CGEvent,
                                            userData: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    return SpiceKeyManager.shared.catchModifersEvent(event)
}
