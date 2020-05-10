//
//  ModifierKey.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2020/05/11.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import Carbon.HIToolbox.Events

public enum ModifierKey {
    
    case leftControl
    case rightControl
    case leftOption
    case rightOption
    case leftShift
    case rightShift
    case leftCommand
    case rightCommand
    
    public init?(keyCode: UInt16) {
        switch Int(keyCode) {
        case kVK_Control:      self = .leftControl
        case kVK_RightControl: self = .rightControl
        case kVK_Option:       self = .leftOption
        case kVK_RightOption:  self = .rightOption
        case kVK_Shift:        self = .leftShift
        case kVK_RightShift:   self = .rightShift
        case kVK_Command:      self = .leftCommand
        case kVK_RightCommand: self = .rightCommand
        default: return nil
        }
    }
    
    public var keyCode: UInt16 {
        var keyCode: Int
        switch self {
        case .leftControl:   keyCode = kVK_Control
        case .rightControl:  keyCode = kVK_RightControl
        case .leftOption:    keyCode = kVK_Option
        case .rightOption:   keyCode = kVK_RightOption
        case .leftShift:     keyCode = kVK_Shift
        case .rightShift:    keyCode = kVK_RightShift
        case .leftCommand:   keyCode = kVK_Command
        case .rightCommand:  keyCode = kVK_RightCommand
        }
        return UInt16(keyCode)
    }
    
    internal var keyCode32: UInt32 {
        return UInt32(self.keyCode)
    }
}


