//
//  SpiceKeyData.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/12/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Foundation.NSObject

open class SpiceKeyData: NSObject, NSCoding {
    
    public var primaryKey: String
    public var keyCode: CGKeyCode
    public var control: Bool
    public var option: Bool
    public var shift: Bool
    public var command: Bool
    public var spiceKey: SpiceKey?
    
    public var key: Key? {
        return Key(keyCode: keyCode)
    }
    public var modifierFlags: ModifierFlags? {
        return ModifierFlags(control: control, option: option, shift: shift, command: command)
    }
    public var keyCombination: KeyCombination? {
        guard let key = key, let modifierFlags = modifierFlags else { return nil }
        return KeyCombination(key, modifierFlags)
    }
    
    public init(_ primaryKey: String, _ keyCode: CGKeyCode, _ control: Bool, _ option: Bool, _ shift: Bool, _ command: Bool, _ spiceKey: SpiceKey) {
        self.primaryKey = primaryKey
        self.keyCode = keyCode
        self.control = control
        self.option = option
        self.shift = shift
        self.command = command
        self.spiceKey = spiceKey
    }
    
    public init(_ primaryKey: String, _ key: Key, _ modifierFlags: ModifierFlags, _ spiceKey: SpiceKey) {
        self.primaryKey = primaryKey
        self.keyCode = key.keyCode
        self.control = modifierFlags.containsControl
        self.option = modifierFlags.containsOption
        self.shift = modifierFlags.containsShift
        self.command = modifierFlags.containsCommand
        self.spiceKey = spiceKey
    }
    
    required public init?(coder: NSCoder) {
        primaryKey = (coder.decodeObject(forKey: "primaryKey") as? String) ?? ""
        keyCode = coder.decodeObject(forKey: "keyCode") as! CGKeyCode
        control = coder.decodeBool(forKey: "control")
        option = coder.decodeBool(forKey: "option")
        shift = coder.decodeBool(forKey: "shift")
        command = coder.decodeBool(forKey: "command")
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(primaryKey, forKey: "primaryKey")
        coder.encode(keyCode, forKey: "keyCode")
        coder.encode(control, forKey: "control")
        coder.encode(option, forKey: "option")
        coder.encode(shift, forKey: "shift")
        coder.encode(command, forKey: "command")
    }
    
}
