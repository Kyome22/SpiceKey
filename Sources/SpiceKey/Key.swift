/*
 Key.swift
 SpiceKey

 Created by Takuto Nakamura on 2019/03/03.
 Copyright © 2019 Takuto Nakamura. All rights reserved.
*/

import Carbon.HIToolbox.Events
import SwiftUI

public enum Key: Sendable {
    case a
    case b
    case c
    case d
    case e
    case f
    case g
    case h
    case i
    case j
    case k
    case l
    case m
    case n
    case o
    case p
    case q
    case r
    case s
    case t
    case u
    case v
    case w
    case x
    case y
    case z

    case grave
    case minus
    case equal
    case backslash
    case leftBracket
    case rightBracket
    case semicolon
    case quote
    case comma
    case period
    case slash
    case yen
    case underscore
    // case eisu
    // case kana

    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine

    // case keypad0
    // case keypad1
    // case keypad2
    // case keypad3
    // case keypad4
    // case keypad5
    // case keypad6
    // case keypad7
    // case keypad8
    // case keypad9
    // case keypadDecimal
    // case keypadMultiply
    // case keypadPlus
    // case keypadClear
    // case keypadDivide
    // case keypadEnter
    // case keypadMinus
    // case keypadEquals
    // case keypadComma

    case `return`
    case tab
    case space
    case delete
    case escape
    case forwardDelete
    case upArrow
    case downArrow
    case leftArrow
    case rightArrow
    // case mute
    // case volumeUp
    // case volumeDown
    // case help
    // case home
    // case end
    // case pageUp
    // case pageDown

    // case f1
    // case f2
    // case f3
    // case f4
    // case f5
    // case f6
    // case f7
    // case f8
    // case f9
    // case f10
    // case f11
    // case f12
    // case f13
    // case f14
    // case f15
    // case f16
    // case f17
    // case f18
    // case f19
    // case f20

    public init?(keyCode: CGKeyCode) {
        switch Int(keyCode) {
        case kVK_ANSI_A: self = .a
        case kVK_ANSI_B: self = .b
        case kVK_ANSI_C: self = .c
        case kVK_ANSI_D: self = .d
        case kVK_ANSI_E: self = .e
        case kVK_ANSI_F: self = .f
        case kVK_ANSI_G: self = .g
        case kVK_ANSI_H: self = .h
        case kVK_ANSI_I: self = .i
        case kVK_ANSI_J: self = .j
        case kVK_ANSI_K: self = .k
        case kVK_ANSI_L: self = .l
        case kVK_ANSI_M: self = .m
        case kVK_ANSI_N: self = .n
        case kVK_ANSI_O: self = .o
        case kVK_ANSI_P: self = .p
        case kVK_ANSI_Q: self = .q
        case kVK_ANSI_R: self = .r
        case kVK_ANSI_S: self = .s
        case kVK_ANSI_T: self = .t
        case kVK_ANSI_U: self = .u
        case kVK_ANSI_V: self = .v
        case kVK_ANSI_W: self = .w
        case kVK_ANSI_X: self = .x
        case kVK_ANSI_Y: self = .y
        case kVK_ANSI_Z: self = .z

        case kVK_ANSI_Grave:        self = .grave
        case kVK_ANSI_Minus:        self = .minus
        case kVK_ANSI_Equal:        self = .equal
        case kVK_ANSI_Backslash:    self = .backslash
        case kVK_ANSI_LeftBracket:  self = .leftBracket
        case kVK_ANSI_RightBracket: self = .rightBracket
        case kVK_ANSI_Semicolon:    self = .semicolon
        case kVK_ANSI_Quote:        self = .quote
        case kVK_ANSI_Comma:        self = .comma
        case kVK_ANSI_Period:       self = .period
        case kVK_ANSI_Slash:        self = .slash
        case kVK_JIS_Yen:           self = .yen
        case kVK_JIS_Underscore:    self = .underscore
        // case kVK_JIS_Eisu:          self = .eisu
        // case kVK_JIS_Kana:          self = .kana

        case kVK_ANSI_0: self = .zero
        case kVK_ANSI_1: self = .one
        case kVK_ANSI_2: self = .two
        case kVK_ANSI_3: self = .three
        case kVK_ANSI_4: self = .four
        case kVK_ANSI_5: self = .five
        case kVK_ANSI_6: self = .six
        case kVK_ANSI_7: self = .seven
        case kVK_ANSI_8: self = .eight
        case kVK_ANSI_9: self = .nine

            // case kVK_ANSI_Keypad0:        self = .keypad0
            // case kVK_ANSI_Keypad1:        self = .keypad1
            // case kVK_ANSI_Keypad2:        self = .keypad2
            // case kVK_ANSI_Keypad3:        self = .keypad3
            // case kVK_ANSI_Keypad4:        self = .keypad4
            // case kVK_ANSI_Keypad5:        self = .keypad5
            // case kVK_ANSI_Keypad6:        self = .keypad6
            // case kVK_ANSI_Keypad7:        self = .keypad7
            // case kVK_ANSI_Keypad8:        self = .keypad8
            // case kVK_ANSI_Keypad9:        self = .keypad9
            // case kVK_ANSI_KeypadDecimal:  self = .keypadDecimal
            // case kVK_ANSI_KeypadMultiply: self = .keypadMultiply
            // case kVK_ANSI_KeypadPlus:     self = .keypadPlus
            // case kVK_ANSI_KeypadClear:    self = .keypadClear
            // case kVK_ANSI_KeypadDivide:   self = .keypadDivide
            // case kVK_ANSI_KeypadEnter:    self = .keypadEnter
            // case kVK_ANSI_KeypadMinus:    self = .keypadMinus
            // case kVK_ANSI_KeypadEquals:   self = .keypadEquals
            // case kVK_JIS_KeypadComma:     self = .keypadComma

        case kVK_Return:        self = .return
        case kVK_Tab:           self = .tab
        case kVK_Space:         self = .space
        case kVK_Delete:        self = .delete
        case kVK_Escape:        self = .escape
        case kVK_ForwardDelete: self = .forwardDelete
        case kVK_UpArrow:       self = .upArrow
        case kVK_DownArrow:     self = .downArrow
        case kVK_LeftArrow:     self = .leftArrow
        case kVK_RightArrow:    self = .rightArrow
            // case kVK_Mute:          self = .mute
            // case kVK_VolumeUp:      self = .volumeUp
            // case kVK_VolumeDown:    self = .volumeDown
            // case kVK_Help:          self = .help
            // case kVK_Home:          self = .home
            // case kVK_End:           self = .end
            // case kVK_PageUp:        self = .pageUp
            // case kVK_PageDown:      self = .pageDown

            // case kVK_F1:  self = .f1
            // case kVK_F2:  self = .f2
            // case kVK_F3:  self = .f3
            // case kVK_F4:  self = .f4
            // case kVK_F5:  self = .f5
            // case kVK_F6:  self = .f6
            // case kVK_F7:  self = .f7
            // case kVK_F8:  self = .f8
            // case kVK_F9:  self = .f9
            // case kVK_F10: self = .f10
            // case kVK_F11: self = .f11
            // case kVK_F12: self = .f12
            // case kVK_F13: self = .f13
            // case kVK_F14: self = .f14
            // case kVK_F15: self = .f15
            // case kVK_F16: self = .f16
            // case kVK_F17: self = .f17
            // case kVK_F18: self = .f18
            // case kVK_F19: self = .f19
            // case kVK_F20: self = .f20
        default: return nil
        }
    }

    public var string: String {
        switch self {
        case .a: "A"
        case .b: "B"
        case .c: "C"
        case .d: "D"
        case .e: "E"
        case .f: "F"
        case .g: "G"
        case .h: "H"
        case .i: "I"
        case .j: "J"
        case .k: "K"
        case .l: "L"
        case .m: "M"
        case .n: "N"
        case .o: "O"
        case .p: "P"
        case .q: "Q"
        case .r: "R"
        case .s: "S"
        case .t: "T"
        case .u: "U"
        case .v: "V"
        case .w: "W"
        case .x: "X"
        case .y: "Y"
        case .z: "Z"

        case .grave:        "`"
        case .minus:        "-"
        case .equal:        "="
        case .backslash:    "\\"
        case .leftBracket:  "["
        case .rightBracket: "]"
        case .semicolon:    ";"
        case .quote:        "'"
        case .comma:        ","
        case .period:       "."
        case .slash:        "/"
        case .yen:          "¥"
        case .underscore:   "_"
        // case .eisu:         "Eisu"
        // case .kana:         "Kana"

        case .zero:  "0"
        case .one:   "1"
        case .two:   "2"
        case .three: "3"
        case .four:  "4"
        case .five:  "5"
        case .six:   "6"
        case .seven: "7"
        case .eight: "8"
        case .nine:  "9"

        case .return:        "↩︎"
        case .tab:           "⇥"
        case .space:         "␣"
        case .delete:        "⌫"
        case .escape:        "⎋"
        case .forwardDelete: "⌦"
        case .upArrow:       "↑"
        case .downArrow:     "↓"
        case .leftArrow:     "←"
        case .rightArrow:    "→"
            // case .mute:             "Mute"
            // case .volumeUp:         "VolumeUp"
            // case .volumeDown:       "VolumeDown"
            // case .help:             "?⃝"
            // case .home:             "↖"
            // case .end:              "↘"
            // case .pageUp:           "⇞"
            // case .pageDown:         "⇟"
        }
    }

    public var keyCode: CGKeyCode {
        var keyCode: Int
        switch self {
        case .a: keyCode = kVK_ANSI_A
        case .b: keyCode = kVK_ANSI_B
        case .c: keyCode = kVK_ANSI_C
        case .d: keyCode = kVK_ANSI_D
        case .e: keyCode = kVK_ANSI_E
        case .f: keyCode = kVK_ANSI_F
        case .g: keyCode = kVK_ANSI_G
        case .h: keyCode = kVK_ANSI_H
        case .i: keyCode = kVK_ANSI_I
        case .j: keyCode = kVK_ANSI_J
        case .k: keyCode = kVK_ANSI_K
        case .l: keyCode = kVK_ANSI_L
        case .m: keyCode = kVK_ANSI_M
        case .n: keyCode = kVK_ANSI_N
        case .o: keyCode = kVK_ANSI_O
        case .p: keyCode = kVK_ANSI_P
        case .q: keyCode = kVK_ANSI_Q
        case .r: keyCode = kVK_ANSI_R
        case .s: keyCode = kVK_ANSI_S
        case .t: keyCode = kVK_ANSI_T
        case .u: keyCode = kVK_ANSI_U
        case .v: keyCode = kVK_ANSI_V
        case .w: keyCode = kVK_ANSI_W
        case .x: keyCode = kVK_ANSI_X
        case .y: keyCode = kVK_ANSI_Y
        case .z: keyCode = kVK_ANSI_Z

        case .grave:        keyCode = kVK_ANSI_Grave
        case .minus:        keyCode = kVK_ANSI_Minus
        case .equal:        keyCode = kVK_ANSI_Equal
        case .backslash:    keyCode = kVK_ANSI_Backslash
        case .leftBracket:  keyCode = kVK_ANSI_LeftBracket
        case .rightBracket: keyCode = kVK_ANSI_RightBracket
        case .semicolon:    keyCode = kVK_ANSI_Semicolon
        case .quote:        keyCode = kVK_ANSI_Quote
        case .comma:        keyCode = kVK_ANSI_Comma
        case .period:       keyCode = kVK_ANSI_Period
        case .slash:        keyCode = kVK_ANSI_Slash
        case .yen:          keyCode = kVK_JIS_Yen
        case .underscore:   keyCode = kVK_JIS_Underscore
        // case .eisu:         keyCode = kVK_JIS_Eisu
        // case .kana:         keyCode = kVK_JIS_Kana

        case .zero:  keyCode = kVK_ANSI_0
        case .one:   keyCode = kVK_ANSI_1
        case .two:   keyCode = kVK_ANSI_2
        case .three: keyCode = kVK_ANSI_3
        case .four:  keyCode = kVK_ANSI_4
        case .five:  keyCode = kVK_ANSI_5
        case .six:   keyCode = kVK_ANSI_6
        case .seven: keyCode = kVK_ANSI_7
        case .eight: keyCode = kVK_ANSI_8
        case .nine:  keyCode = kVK_ANSI_9

        case .return:        keyCode = kVK_Return
        case .tab:           keyCode = kVK_Tab
        case .space:         keyCode = kVK_Space
        case .delete:        keyCode = kVK_Delete
        case .escape:        keyCode = kVK_Escape
        case .forwardDelete: keyCode = kVK_ForwardDelete
        case .upArrow:       keyCode = kVK_UpArrow
        case .downArrow:     keyCode = kVK_DownArrow
        case .leftArrow:     keyCode = kVK_LeftArrow
        case .rightArrow:    keyCode = kVK_RightArrow
            // case .mute:          keyCode = kVK_Mute
            // case .volumeUp:      keyCode = kVK_VolumeUp
            // case .volumeDown:    keyCode = kVK_VolumeDown
            // case .help:          keyCode = kVK_Help
            // case .home:          keyCode = kVK_Home
            // case .end:           keyCode = kVK_End
            // case .pageUp:        keyCode = kVK_PageUp
            // case .pageDown:      keyCode = kVK_PageDown
        }
        return CGKeyCode(keyCode)
    }

    var keyCode32: UInt32 {
        return UInt32(self.keyCode)
    }

    public var keyEquivalent: KeyEquivalent {
        switch self {
        case .a: KeyEquivalent("a")
        case .b: KeyEquivalent("b")
        case .c: KeyEquivalent("c")
        case .d: KeyEquivalent("d")
        case .e: KeyEquivalent("e")
        case .f: KeyEquivalent("f")
        case .g: KeyEquivalent("g")
        case .h: KeyEquivalent("h")
        case .i: KeyEquivalent("i")
        case .j: KeyEquivalent("j")
        case .k: KeyEquivalent("k")
        case .l: KeyEquivalent("l")
        case .m: KeyEquivalent("m")
        case .n: KeyEquivalent("n")
        case .o: KeyEquivalent("o")
        case .p: KeyEquivalent("p")
        case .q: KeyEquivalent("q")
        case .r: KeyEquivalent("r")
        case .s: KeyEquivalent("s")
        case .t: KeyEquivalent("t")
        case .u: KeyEquivalent("u")
        case .v: KeyEquivalent("v")
        case .w: KeyEquivalent("w")
        case .x: KeyEquivalent("x")
        case .y: KeyEquivalent("y")
        case .z: KeyEquivalent("z")

        case .grave:        KeyEquivalent("`")
        case .minus:        KeyEquivalent("-")
        case .equal:        KeyEquivalent("=")
        case .backslash:    KeyEquivalent("\\")
        case .leftBracket:  KeyEquivalent("[")
        case .rightBracket: KeyEquivalent("]")
        case .semicolon:    KeyEquivalent(";")
        case .quote:        KeyEquivalent("'")
        case .comma:        KeyEquivalent(",")
        case .period:       KeyEquivalent(".")
        case .slash:        KeyEquivalent("/")
        case .yen:          KeyEquivalent("¥")
        case .underscore:   KeyEquivalent("_")

        case .zero:  KeyEquivalent("0")
        case .one:   KeyEquivalent("1")
        case .two:   KeyEquivalent("2")
        case .three: KeyEquivalent("3")
        case .four:  KeyEquivalent("4")
        case .five:  KeyEquivalent("5")
        case .six:   KeyEquivalent("6")
        case .seven: KeyEquivalent("7")
        case .eight: KeyEquivalent("8")
        case .nine:  KeyEquivalent("9")

        case .return:        .return
        case .tab:           .tab
        case .space:         .space
        case .delete:        .delete
        case .escape:        .escape
        case .forwardDelete: .deleteForward
        case .upArrow:       .upArrow
        case .downArrow:     .downArrow
        case .leftArrow:     .leftArrow
        case .rightArrow:    .rightArrow
            // case .mute:             nil
            // case .volumeUp:         nil
            // case .volumeDown:       nil
            // case .help:             nil
            // case .home:             .home
            // case .end:              .end
            // case .pageUp:           .pageUp
            // case .pageDown:         .pageDown
        }
    }
}
