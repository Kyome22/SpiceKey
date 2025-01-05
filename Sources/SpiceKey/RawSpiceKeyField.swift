/*
 RawSpiceKeyField.swift
 SpiceKey

 Created by Takuto Nakamura on 2019/12/08.
 Copyright © 2019 Takuto Nakamura. All rights reserved.
*/

import AppKit

protocol RawSpiceKeyFieldDelegate: NSTextFieldDelegate {
    @MainActor func didRegisterSpiceKey(_ field: RawSpiceKeyField, _ key: Key, _ flags: ModifierFlags)
    @MainActor func didDelete(_ field: RawSpiceKeyField)
}

public final class RawSpiceKeyField: NSTextField {
    private var isTyping: Bool = false
    private var skfDelegate: (any RawSpiceKeyFieldDelegate)? {
        delegate as? (any RawSpiceKeyFieldDelegate)
    }
    private var deleteButton: SpiceKeyDeleteButton!

    public override init(frame: NSRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        refusesFirstResponder = true
        isSelectable = false
        isEditable = true
        isEnabled = true
        isBordered = true
        wantsLayer = true
        layer?.borderColor = CGColor(red: 0.69, green: 0.745, blue: 0.773, alpha: 1.0)
        layer?.borderWidth = 1.0
        layer?.cornerRadius = 4.0
        textColor = NSColor.secondaryLabelColor

        let rect = NSRect(origin: .zero, size: CGSize(width: 20, height: 20))
        deleteButton = SpiceKeyDeleteButton(frame: rect)
        addSubview(deleteButton)
        deleteButton.target = self
        deleteButton.action = #selector(self.delete)
        deleteButton.isEnabled = false

        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    private func register(key: Key, modifierFlags: ModifierFlags) {
        stringValue = modifierFlags.string + key.string
        isEditable = false
        window?.makeFirstResponder(nil)
        isTyping = false
        deleteButton.isEnabled = true
        skfDelegate?.didRegisterSpiceKey(self, key, modifierFlags)
    }
    
    public override func textDidChange(_ notification: Notification) {
        guard let event = NSApp.currentEvent, performKeyEquivalent(with: event) else {
            stringValue = ""
            return
        }
    }
    
    public override func flagsChanged(with event: NSEvent) {
        let flags = event.modifierFlags.pureFlags
        let modifierFlags = ModifierFlags(flags: flags)
        isTyping = (modifierFlags != .empty)
        stringValue = modifierFlags.string
        super.flagsChanged(with: event)
    }
    
    public override func performKeyEquivalent(with event: NSEvent) -> Bool {
        guard isTyping, let key = Key(keyCode: event.keyCode) else {
            return isTyping
        }
        let flags = event.modifierFlags.pureFlags
        let modifierFlags = ModifierFlags(flags: flags)
        register(key: key, modifierFlags: modifierFlags)
        return true
    }
    
    public override func resetCursorRects() {
        let rectL = NSRect(x: 0, y: 0, width: bounds.width - 20.0, height: bounds.height)
        addCursorRect(rectL, cursor: NSCursor.iBeam)
        
        let rectR = NSRect(x: bounds.width - 20.0, y: 0.5 * (bounds.height - 20.0), width: 20.0, height: 20.0)
        addCursorRect(rectR, cursor: NSCursor.pointingHand)
    }
    
    public override var needsPanelToBecomeKey: Bool { true }
    
    @objc func delete() {
        stringValue = ""
        isEditable = true
        deleteButton.isEnabled = false
        skfDelegate?.didDelete(self)
    }
    
    public func setKeyCombination(_ keyCombination: KeyCombination) {
        stringValue = keyCombination.string
        isEditable = false
        deleteButton.isEnabled = true
    }
}
