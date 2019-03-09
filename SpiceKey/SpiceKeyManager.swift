//
//  SpiceKeyManager.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import AppKit
import Carbon

final class SpiceKeyManager {
    
    public static let shared = SpiceKeyManager()
    internal var spiceKeys = [UUID : SpiceKey]()
    private let signature = UTGetOSTypeFromString("SpiceKey" as CFString)
    private var count: UInt32 = 0
    
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
        
        //        let event = CGEvent.tapCreate(tap: CGEventTapLocation.cghidEventTap,
        //                                      place: CGEventTapPlacement.headInsertEventTap,
        //                                      options: CGEventTapOptions.listenOnly,
        //                                      eventsOfInterest: CGEventMask(1 << CGEventType.flagsChanged.rawValue),
        //                                      callback: modifierEventHandleNegotiator,
        //                                      userInfo: nil)
        //        if event != nil {
        //            let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, event!, 0)
        //            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, CFRunLoopMode.commonModes)
        //            CGEvent.tapEnable(tap: event!, enable: true)
        //        }
    }
    
    deinit {
        // (๑╹ω╹๑ )??
    }
    
    func register(_ spiceKey: SpiceKey) {
        if spiceKeys.contains(where: { (keyData) -> Bool in
            return keyData.key == spiceKey.uuid
        }) {
            return
        }
        count += 1
        spiceKeys[spiceKey.uuid] = spiceKey
        
        let keyCode32 = spiceKey.keyCombination.key.keyCode32
        let flags32 = spiceKey.keyCombination.modifierFlags.flags32
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
    
    func unregister(_ spiceKey: SpiceKey) {
        if !spiceKeys.values.contains(where: { (spiceKey_) -> Bool in
            return spiceKey.identifier == spiceKey_.identifier
        }) {
            return
        }
        UnregisterEventHotKey(spiceKey.eventHotKey)
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
}

private func eventHandleNegotiator(eventHandlerCall: EventHandlerCallRef?,
                                   event: EventRef?,
                                   userData: UnsafeMutableRawPointer?) -> OSStatus {
    return SpiceKeyManager.shared.handleEvent(event)
}

//private func modifierEventHandleNegotiator(proxy: CGEventTapProxy,
//                                           type: CGEventType,
//                                           event: CGEvent,
//                                           userData: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
//    return SpiceKeyManager.shared.handleModifierEvent(event)
//}
