//
//  KeyCombination.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

public struct KeyCombination {
    public var key: Key
    public var modifierFlags: ModifierFlags
    public var string: String {
        return modifierFlags.string + key.string
    }
    
    public init(_ key: Key, _ modifierFlags: ModifierFlags) {
        self.key = key
        self.modifierFlags = modifierFlags
    }
}

public func ==(lhs: KeyCombination, rhs: KeyCombination) -> Bool {
    return lhs.key == rhs.key && lhs.modifierFlags == rhs.modifierFlags
}
