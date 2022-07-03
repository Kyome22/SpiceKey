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
        refusesFirstResponder = true
        wantsLayer = true
        layer?.borderColor = CGColor(red: 0.69, green: 0.745, blue: 0.773, alpha: 1.0)
        layer?.borderWidth = 1.0
        layer?.cornerRadius = 4.0
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
        isTyping = false
        isEnabled = false
        deleteButton.isEnabled = true
        skfDelegate?.didRegisterSpiceKey(self, key, modifierFlags)
    }
    
    open override func textDidChange(_ notification: Notification) {
        guard let event = NSApp.currentEvent,
              performKeyEquivalent(with: event)
        else {
            stringValue = ""
            return
        }
    }
    
    open override func flagsChanged(with event: NSEvent) {
        let flags = event.modifierFlags.pureFlags
        let modifierFlags = ModifierFlags(flags: flags)
        isTyping = (modifierFlags != .empty)
        stringValue = modifierFlags.string
        super.flagsChanged(with: event)
    }
    
    open override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if isTyping, let key = Key(keyCode: event.keyCode) {
            let flags = event.modifierFlags.pureFlags
            let modifierFlags = ModifierFlags(flags: flags)
            register(key: key, modifierFlags: modifierFlags)
            return true
        }
        return isTyping
    }
    
    open override func resetCursorRects() {
        let rectL = NSRect(x: 0,
                           y: 0,
                           width: bounds.width - 20.0,
                           height: bounds.height)
        addCursorRect(rectL, cursor: NSCursor.iBeam)
        
        let rectR = NSRect(x: bounds.width - 20.0,
                           y: 0.5 * (bounds.height - 20.0),
                           width: 20.0,
                           height: 20.0)
        addCursorRect(rectR, cursor: NSCursor.pointingHand)
    }
    
    open override var needsPanelToBecomeKey: Bool {
        return true
    }
    
    @objc func delete() {
        stringValue = ""
        isEnabled = true
        deleteButton.isEnabled = false
        skfDelegate?.didDelete(self)
    }
    
    public func setInitialKeyCombination(_ keyCombination: KeyCombination) {
        stringValue = keyCombination.string
        isEnabled = false
        deleteButton.isEnabled = true
    }
}
