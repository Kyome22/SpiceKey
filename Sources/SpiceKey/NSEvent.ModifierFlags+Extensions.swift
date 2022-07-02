//
//  File.swift
//  
//
//  Created by Takuto Nakamura on 2021/08/01.
//

import AppKit.NSEvent
import Carbon

public extension NSEvent.ModifierFlags {
    var pureFlags: Self {
        var flags = Self.init()
        if self.contains(.control) {
            flags.insert(.control)
        }
        if self.contains(.option) {
            flags.insert(.option)
        }
        if self.contains(.shift) {
            flags.insert(.shift)
        }
        if self.contains(.command) {
            flags.insert(.command)
        }
        return flags
    }
}
