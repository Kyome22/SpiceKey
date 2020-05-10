//
//  ModifierFlags.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import AppKit.NSEvent
import Carbon.HIToolbox.Events

public enum ModifierFlags {
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
    
    public init?(control: Bool = false,
                 option: Bool = false,
                 shift: Bool = false,
                 command: Bool = false) {
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
        case .empty:         return ""
        case .ctrl:          return "⌃"
        case .opt:           return "⌥"
        case .sft:           return "⇧"
        case .cmd:           return "⌘"
        case .ctrlOpt:       return "⌃⌥"
        case .ctrlSft:       return "⌃⇧"
        case .ctrlCmd:       return "⌃⌘"
        case .optSft:        return "⌥⇧"
        case .optCmd:        return "⌥⌘"
        case .sftCmd:        return "⇧⌘"
        case .ctrlOptSft:    return "⌃⌥⇧"
        case .ctrlOptCmd:    return "⌃⌥⌘"
        case .ctrlSftCmd:    return "⌃⇧⌘"
        case .optSftCmd:     return "⌥⇧⌘"
        case .ctrlOptSftCmd: return "⌃⌥⇧⌘"
        }
    }
    
    public var flags: NSEvent.ModifierFlags {
        switch self {
        case .empty:         return NSEvent.ModifierFlags()
        case .ctrl:          return [.control]
        case .opt:           return [.option]
        case .sft:           return [.shift]
        case .cmd:           return [.command]
        case .ctrlOpt:       return [.control, .option]
        case .ctrlSft:       return [.control, .shift]
        case .ctrlCmd:       return [.control, .command]
        case .optSft:        return [.option,  .shift]
        case .optCmd:        return [.option,  .command]
        case .sftCmd:        return [.shift,   .command]
        case .ctrlOptSft:    return [.control, .option, .shift]
        case .ctrlOptCmd:    return [.control, .option, .command]
        case .ctrlSftCmd:    return [.control, .shift,  .command]
        case .optSftCmd:     return [.option,  .shift,  .command]
        case .ctrlOptSftCmd: return [.control, .option, .shift, .command]
        }
    }
    
    public var containsControl: Bool {
        return self.flags.contains(NSEvent.ModifierFlags.control)
    }
    
    public var containsOption: Bool {
        return self.flags.contains(NSEvent.ModifierFlags.option)
    }
    
    public var containsShift: Bool {
        return self.flags.contains(NSEvent.ModifierFlags.shift)
    }
    
    public var containsCommand: Bool {
        return self.flags.contains(NSEvent.ModifierFlags.command)
    }
    
    internal var flags32: UInt32 {
        var flags: UInt32 = 0
        if self.flags.contains(.control) {
            flags |= UInt32(controlKey)
        }
        if self.flags.contains(.option) {
            flags |= UInt32(optionKey)
        }
        if self.flags.contains(.shift) {
            flags |= UInt32(shiftKey)
        }
        if self.flags.contains(.command) {
            flags |= UInt32(cmdKey)
        }
        return flags
    }
}
