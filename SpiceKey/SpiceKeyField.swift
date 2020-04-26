//
//  SpiceKeyField.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/12/08.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

public protocol SpiceKeyFieldDelegate: NSTextFieldDelegate {
    func didRegisterSpiceKey(_ field: SpiceKeyField, _ key: Key, _ flags: ModifierFlags)
    func didDelete(_ field: SpiceKeyField)
}

open class SpiceKeyField: NSTextField {
    
    private var isTyping: Bool = false
    private var skfDelegate: SpiceKeyFieldDelegate? {
        return delegate as? SpiceKeyFieldDelegate
    }
    private var deleteButton: SpiceKeyDeleteButton!
    public var id: String?
    
    public init(frame: NSRect, id: String? = nil) {
        super.init(frame: frame)
        self.id = id
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        isBordered = true
        isEditable = true
        isEnabled = true
        wantsLayer = true
        layer?.borderColor = CGColor(red: 0.69, green: 0.745, blue: 0.773, alpha: 1.0)
        layer?.borderWidth = 1.0
        layer?.cornerRadius = 4.0
        let rect = NSRect(x: frame.width - 20.0, y: 0.5 * (frame.height - 20.0),
                          width: 20.0, height: 20.0)
        deleteButton = SpiceKeyDeleteButton(frame: rect)
        addSubview(deleteButton)
        deleteButton.target = self
        deleteButton.action = #selector(self.delete)
        deleteButton.isEnabled = false
    }
    
    override open func textDidChange(_ notification: Notification) {
        stringValue = ""
    }
    
    override open func flagsChanged(with event: NSEvent) {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        if let modifierFlags = ModifierFlags(flags: flags) {
            isTyping = true
            stringValue = modifierFlags.string
        } else {
            isTyping = false
            stringValue = ""
        }
        super.flagsChanged(with: event)
    }
    
    override open func performKeyEquivalent(with event: NSEvent) -> Bool {
        if isTyping, let key = Key(keyCode: event.keyCode) {
            let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            let modifierFlags = ModifierFlags(flags: flags)!
            stringValue = modifierFlags.string + key.string
            isTyping = false
            isEnabled = false
            deleteButton.isEnabled = true
            skfDelegate?.didRegisterSpiceKey(self, key, modifierFlags)
            return true
        }
        return isTyping
    }
    
    override open func resetCursorRects() {
        let rectL = NSRect(x: 0, y: 0, width: bounds.width - 20.0, height: 20.0)
        let cursorL: NSCursor = NSCursor.iBeam
        addCursorRect(rectL, cursor: cursorL)
        
        let rectR = NSRect(x: bounds.width - 20.0, y: 0, width: 20.0, height: 20.0)
        let cursorR: NSCursor = NSCursor.pointingHand
        addCursorRect(rectR, cursor: cursorR)
    }
    
    @objc func delete() {
        stringValue = ""
        isEnabled = true
        deleteButton.isEnabled = false
        skfDelegate?.didDelete(self)
    }
    
    public func setInitialSpiceKey(string: String) {
        stringValue = string
        isEnabled = false
        deleteButton.isEnabled = true
    }
    
}
