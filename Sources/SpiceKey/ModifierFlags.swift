/*
 ModifierFlags.swift
 SpiceKey

 Created by Takuto Nakamura on 2019/03/03.
 Copyright © 2019 Takuto Nakamura. All rights reserved.
*/

import AppKit.NSEvent
import Carbon.HIToolbox.Events
import SwiftUI

public enum ModifierFlags: Int, CaseIterable, Sendable {
    case empty
    case ctrl           // ⌃
    case opt            // ⌥
    case sft            // ⇧
    case cmd            // ⌘
    case ctrlOpt        // ⌃⌥
    case ctrlSft        // ⌃⇧
    case ctrlCmd        // ⌃⌘
    case optSft         // ⌥⇧
    case optCmd         // ⌥⌘
    case sftCmd         // ⇧⌘
    case ctrlOptSft     // ⌃⌥⇧
    case ctrlOptCmd     // ⌃⌥⌘
    case ctrlSftCmd     // ⌃⇧⌘
    case optSftCmd      // ⌥⇧⌘
    case ctrlOptSftCmd  // ⌃⌥⇧⌘
    
    public init(flags: NSEvent.ModifierFlags) {
        switch flags {
        case [.control]: self = .ctrl
        case [.option]:  self = .opt
        case [.shift]:   self = .sft
        case [.command]: self = .cmd
        case [.control, .option]:  self = .ctrlOpt
        case [.control, .shift]:   self = .ctrlSft
        case [.control, .command]: self = .ctrlCmd
        case [.option,  .shift]:   self = .optSft
        case [.option,  .command]: self = .optCmd
        case [.shift,   .command]: self = .sftCmd
        case [.control, .option, .shift]:   self = .ctrlOptSft
        case [.control, .option, .command]: self = .ctrlOptCmd
        case [.control, .shift,  .command]: self = .ctrlSftCmd
        case [.option,  .shift,  .command]: self = .optSftCmd
        case [.control, .option, .shift, .command]: self = .ctrlOptSftCmd
        default: self = .empty
        }
    }
    
    public init(_ modifierFlag: ModifierFlag) {
        switch modifierFlag {
        case .control: self = .ctrl
        case .option:  self = .opt
        case .shift:   self = .sft
        case .command: self = .cmd
        }
    }
    
    public init?(
        control: Bool = false,
        option: Bool = false,
        shift: Bool = false,
        command: Bool = false
    ) {
        if !(control || option || shift || command) {
            return nil
        }
        var flags = NSEvent.ModifierFlags()
        if control { flags = flags.union(.control) }
        if option { flags = flags.union(.option) }
        if shift { flags = flags.union(.shift) }
        if command { flags = flags.union(.command) }
        self.init(flags: flags)
    }
    
    public var string: String {
        switch self {
        case .empty:         ""
        case .ctrl:          "⌃"
        case .opt:           "⌥"
        case .sft:           "⇧"
        case .cmd:           "⌘"
        case .ctrlOpt:       "⌃⌥"
        case .ctrlSft:       "⌃⇧"
        case .ctrlCmd:       "⌃⌘"
        case .optSft:        "⌥⇧"
        case .optCmd:        "⌥⌘"
        case .sftCmd:        "⇧⌘"
        case .ctrlOptSft:    "⌃⌥⇧"
        case .ctrlOptCmd:    "⌃⌥⌘"
        case .ctrlSftCmd:    "⌃⇧⌘"
        case .optSftCmd:     "⌥⇧⌘"
        case .ctrlOptSftCmd: "⌃⌥⇧⌘"
        }
    }

    public var title: String {
        switch self {
        case .empty:         "empty"
        case .ctrl:          "control"
        case .opt:           "option"
        case .sft:           "shift"
        case .cmd:           "command"
        case .ctrlOpt:       "ctrl + opt"
        case .ctrlSft:       "ctrl + sft"
        case .ctrlCmd:       "ctrl + cmd"
        case .optSft:        "opt + sft"
        case .optCmd:        "opt + cmd"
        case .sftCmd:        "sft + cmd"
        case .ctrlOptSft:    "ctrl + opt + sft"
        case .ctrlOptCmd:    "ctrl + opt + cmd"
        case .ctrlSftCmd:    "ctrl + sft + cmd"
        case .optSftCmd:     "opt + sft + cmd"
        case .ctrlOptSftCmd: "ctrl + opt + sft + cmd"
        }
    }
    
    public var flags: NSEvent.ModifierFlags {
        switch self {
        case .empty:         NSEvent.ModifierFlags()
        case .ctrl:          [.control]
        case .opt:           [.option]
        case .sft:           [.shift]
        case .cmd:           [.command]
        case .ctrlOpt:       [.control, .option]
        case .ctrlSft:       [.control, .shift]
        case .ctrlCmd:       [.control, .command]
        case .optSft:        [.option,  .shift]
        case .optCmd:        [.option,  .command]
        case .sftCmd:        [.shift,   .command]
        case .ctrlOptSft:    [.control, .option, .shift]
        case .ctrlOptCmd:    [.control, .option, .command]
        case .ctrlSftCmd:    [.control, .shift,  .command]
        case .optSftCmd:     [.option,  .shift,  .command]
        case .ctrlOptSftCmd: [.control, .option, .shift, .command]
        }
    }

    public var eventModifiers: SwiftUI.EventModifiers {
        switch self {
        case .empty:         []
        case .ctrl:          [.control]
        case .opt:           [.option]
        case .sft:           [.shift]
        case .cmd:           [.command]
        case .ctrlOpt:       [.control, .option]
        case .ctrlSft:       [.control, .shift]
        case .ctrlCmd:       [.control, .command]
        case .optSft:        [.option,  .shift]
        case .optCmd:        [.option,  .command]
        case .sftCmd:        [.shift,   .command]
        case .ctrlOptSft:    [.control, .option, .shift]
        case .ctrlOptCmd:    [.control, .option, .command]
        case .ctrlSftCmd:    [.control, .shift,  .command]
        case .optSftCmd:     [.option,  .shift,  .command]
        case .ctrlOptSftCmd: [.control, .option, .shift, .command]
        }
    }

    public var containsControl: Bool {
        flags.contains(NSEvent.ModifierFlags.control)
    }
    
    public var containsOption: Bool {
        flags.contains(NSEvent.ModifierFlags.option)
    }
    
    public var containsShift: Bool {
        flags.contains(NSEvent.ModifierFlags.shift)
    }
    
    public var containsCommand: Bool {
        flags.contains(NSEvent.ModifierFlags.command)
    }
    
    var flags32: UInt32 {
        var _flags: UInt32 = 0
        if flags.contains(.control) {
            _flags |= UInt32(controlKey)
        }
        if flags.contains(.option) {
            _flags |= UInt32(optionKey)
        }
        if flags.contains(.shift) {
            _flags |= UInt32(shiftKey)
        }
        if flags.contains(.command) {
            _flags |= UInt32(cmdKey)
        }
        return _flags
    }
}
