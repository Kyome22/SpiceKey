/*
 ModifierFlag.swift
 SpiceKey

 Created by Takuto Nakamura on 2019/05/31.
 Copyright © 2019 Takuto Nakamura. All rights reserved.
*/

import AppKit.NSEvent
import SwiftUI

public enum ModifierFlag: Int, CaseIterable {
    case control // ⌃
    case option  // ⌥
    case shift   // ⇧
    case command // ⌘
    
    public init?(flags: NSEvent.ModifierFlags) {
        switch flags {
        case NSEvent.ModifierFlags.control: self = .control
        case NSEvent.ModifierFlags.option:  self = .option
        case NSEvent.ModifierFlags.shift:   self = .shift
        case NSEvent.ModifierFlags.command: self = .command
        default: return nil
        }
    }
    
    public var string: String {
        switch self {
        case .control: return "⌃"
        case .option:  return "⌥"
        case .shift:   return "⇧"
        case .command: return "⌘"
        }
    }

    public var title: String {
        switch self {
        case .control: return String(localized: "control", bundle: .module)
        case .option:  return String(localized: "option", bundle: .module)
        case .shift:   return String(localized: "shift", bundle: .module)
        case .command: return String(localized: "command", bundle: .module)
        }
    }

    public var flags: ModifierFlags {
        switch self {
        case .control: return .ctrl
        case .option:  return .opt
        case .shift:   return .sft
        case .command: return .cmd
        }
    }

    public var eventModifiers: EventModifiers {
        switch self {
        case .control: return .control
        case .option:  return .option
        case .shift:   return .shift
        case .command: return .command
        }
    }
}
