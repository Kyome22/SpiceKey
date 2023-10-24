/*
 ModifierBothFlags.swift
 SpiceKey

 Created by Takuto Nakamura on 2020/11/13.
 Copyright © 2020 Takuto Nakamura. All rights reserved.
*/

import AppKit.NSEvent
import Carbon.HIToolbox.Events

public struct ModifierBothFlags {
    public let isLControl: Bool
    public let isRControl: Bool
    public let isLOption: Bool
    public let isROption: Bool
    public let isLShift: Bool
    public let isRShift: Bool
    public let isLCommand: Bool
    public let isRCommand: Bool

    public init(modifierFlags: NSEvent.ModifierFlags) {
        self.isLControl = (modifierFlags.rawValue & UInt(NX_DEVICELCTLKEYMASK)) != 0
        self.isRControl = (modifierFlags.rawValue & UInt(NX_DEVICERCTLKEYMASK)) != 0
        self.isLOption = (modifierFlags.rawValue & UInt(NX_DEVICELALTKEYMASK)) != 0
        self.isROption = (modifierFlags.rawValue & UInt(NX_DEVICERALTKEYMASK)) != 0
        self.isLShift = (modifierFlags.rawValue & UInt(NX_DEVICELSHIFTKEYMASK)) != 0
        self.isRShift = (modifierFlags.rawValue & UInt(NX_DEVICERSHIFTKEYMASK)) != 0
        self.isLCommand = (modifierFlags.rawValue & UInt(NX_DEVICELCMDKEYMASK)) != 0
        self.isRCommand = (modifierFlags.rawValue & UInt(NX_DEVICERCMDKEYMASK)) != 0
    }

    public var isControl: Bool { return isLControl || isRControl }

    public var isOption: Bool { return isLOption || isROption }

    public var isShift: Bool { return isLShift || isRShift }

    public var isCommand: Bool { return isLCommand || isRCommand }

    public var isBothControl: Bool {
        return isLControl && isRControl && !isOption && !isShift && !isCommand
    }

    public var isBothOption: Bool {
        return !isControl && isLOption && isROption && !isShift && !isCommand
    }

    public var isBothShift: Bool {
        return !isControl && !isOption && isLShift && isRShift && !isCommand
    }

    public var isBothCommand: Bool {
        return !isControl && !isOption && !isShift && isLCommand && isRCommand
    }

    public var isBoth: Bool {
        switch (isBothControl, isBothOption, isBothShift, isBothCommand) {
        case (true, false, false, false),
            (false, true, false, false),
            (false, false, true, false),
            (false, false, false, true):
            return true
        default:
            return false
        }
    }
}
