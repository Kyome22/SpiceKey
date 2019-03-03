//
//  KeyCombination.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import AppKit

public struct KeyCombination {
    public var key: Key
    public var modifierFlags: ModifierFlags
    // public var interval: Double = 0.0
    
    public init(key: Key, modifierFlags: ModifierFlags) {
        self.key = key
        self.modifierFlags = modifierFlags
    }
    
    //    public init(modifierFlags: ModifierFlags, interval: Double) {
    //        self.modifierFlags = modifierFlags
    //        self.interval = interval
    //    }
}
