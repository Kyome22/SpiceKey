//
//  Key.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Carbon.HIToolbox.Events

public struct Key: Equatable {
    
    let character: Character
    let keyCode: UInt16
    
    public var string: String {
        switch self.character {
        case "\u{0009}": return "⇥"
        case "\u{000A}": return "↩︎"
        case "\u{000D}": return "↩︎"
        case "\u{0020}": return "␣"
            
        // I can't understand a behavior that displayed `⌘⌦` when I pressed `⌘⌫`.
        // U+007F is "DELETE."
        // U+0008 is "BACK SPACE."
        case "\u{007F}": return "⌫"
//        case "\u{007F}": return "⌦"
        
        case "\u{001B}": return "⎋"
        case "\u{001C}": return "←"
        case "\u{001D}": return "→"
        case "\u{001F}": return "↓"
        case "\u{001E}": return "↑"
        default: return character.description.uppercased()
        }
    }
    
    internal var keyCode32: UInt32 {
        return UInt32(self.keyCode)
    }
}

