//
//  ModifierFlag.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/05/31.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import AppKit
import Carbon

public enum ModifierFlag {
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
    
    public var flags: ModifierFlags {
        switch self {
        case .control: return .ctrl
        case .option:  return .opt
        case .shift:   return .sft
        case .command: return .cmd
        }
    }
}


