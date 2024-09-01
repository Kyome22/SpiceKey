/*
 ModifierFlag.swift
 SpiceKey

 Created by Takuto Nakamura on 2019/05/31.
 Copyright © 2019 Takuto Nakamura. All rights reserved.
*/

import AppKit.NSEvent
import SwiftUI

public enum ModifierFlag: Int, CaseIterable, Sendable {
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
        case .control: "⌃"
        case .option:  "⌥"
        case .shift:   "⇧"
        case .command: "⌘"
        }
    }

    public var title: String {
        switch self {
        case .control: String(localized: "control", bundle: .module)
        case .option:  String(localized: "option", bundle: .module)
        case .shift:   String(localized: "shift", bundle: .module)
        case .command: String(localized: "command", bundle: .module)
        }
    }

    public var flags: ModifierFlags {
        switch self {
        case .control: .ctrl
        case .option:  .opt
        case .shift:   .sft
        case .command: .cmd
        }
    }

    public var eventModifiers: EventModifiers {
        switch self {
        case .control: .control
        case .option:  .option
        case .shift:   .shift
        case .command: .command
        }
    }
}
