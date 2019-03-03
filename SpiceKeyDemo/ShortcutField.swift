//
//  ShortcutField.swift
//  SpiceKeyDemo
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

class ShortcutField: NSTextField {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.placeholderString = "Type Shortcut"
        self.wantsLayer = true
        self.isBordered = true
        self.isSelectable = false
        self.isEditable = false
        self.layer?.borderColor = NSColor(hex: "B0BEC5").cgColor
        self.layer?.borderWidth = 1.0
        self.layer?.cornerRadius = 4.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func resetCursorRects() {
        let rectL = NSRect(x: 0, y: 0, width: bounds.width - 25, height: 25)
        let cursorL: NSCursor = NSCursor.iBeam
        addCursorRect(rectL, cursor: cursorL)
        
        let rectR = NSRect(x: bounds.width - 25, y: 0, width: 25, height: 25)
        let cursorR: NSCursor = NSCursor.pointingHand
        addCursorRect(rectR, cursor: cursorR)
    }
    
}
