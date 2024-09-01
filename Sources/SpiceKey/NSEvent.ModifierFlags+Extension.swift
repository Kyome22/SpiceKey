/*
 NSEvent.ModifierFlags+Extension.swift
 SpiceKey

 Created by Takuto Nakamura on 2021/08/01.
 Copyright © 2019 Takuto Nakamura. All rights reserved.
*/

import AppKit.NSEvent
import Carbon

public extension NSEvent.ModifierFlags {
    var pureFlags: Self {
        var flags = Self.init()
        if contains(.control) {
            flags.insert(.control)
        }
        if contains(.option) {
            flags.insert(.option)
        }
        if contains(.shift) {
            flags.insert(.shift)
        }
        if contains(.command) {
            flags.insert(.command)
        }
        return flags
    }
}
