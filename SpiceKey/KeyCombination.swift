//
//  KeyCombination.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

public struct KeyCombination {
    public var key: Character
    public var modifierFlags: ModifierFlags
    public var string: String {
        return modifierFlags.string + key.description
    }
    
    public init(_ key: Character, _ modifierFlags: ModifierFlags) {
        self.key = key
        self.modifierFlags = modifierFlags
    }
}

public func ==(lhs: KeyCombination, rhs: KeyCombination) -> Bool {
    return lhs.key == rhs.key && lhs.modifierFlags == rhs.modifierFlags
}
