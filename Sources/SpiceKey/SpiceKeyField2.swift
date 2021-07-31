//
//  File.swift
//  
//
//  Created by Takuto Nakamura on 2021/08/01.
//

import Cocoa

public protocol SpiceKeyField2Delegate: AnyObject {
    func didRegisterSpiceKey(_ field: SpiceKeyField2, _ keyCombination : KeyCombination)
    func didDelete(_ field: SpiceKeyField2)
}

open class SpiceKeyField2: NSView {

    public weak var delegate: SpiceKeyField2Delegate?
    private var deleteButton: SpiceKeyDeleteButton!
    public var id: String?
    private var currentFlags: ModifierFlags?
    private var currentKeyCombination: KeyCombination?
    
    public var isEnabled = true {
        didSet {
            self.needsDisplay = true
            self.noteFocusRingMaskChanged()
        }
    }
    
    public private(set) var isTyping = false {
        willSet {
            print("isTyping: \(newValue)")
        }
    }
    
    private var isFirstResponder: Bool {
        return (isEnabled && isTyping && self.window?.firstResponder == self)
    }
    
    open override var isOpaque: Bool {
        return false
    }
    
    open override var focusRingMaskBounds: NSRect {
        return isFirstResponder ? self.bounds : .zero
    }
    
    open override var acceptsFirstResponder: Bool {
        return isEnabled
    }
    
    open override var canBecomeKeyView: Bool {
        return super.canBecomeKeyView && NSApp.isFullKeyboardAccessEnabled
    }
    
    open override var needsPanelToBecomeKey: Bool {
        return true
    }
    
    open override func becomeFirstResponder() -> Bool {
        return focusField()
    }
    
    open override func resignFirstResponder() -> Bool {
        unfocusField()
        return super.resignFirstResponder()
    }
    
    // Key Event
    open override func cancelOperation(_ sender: Any?) {
        endTyping()
    }
    
    open override func performKeyEquivalent(with event: NSEvent) -> Bool {
        guard isFirstResponder else { return false }
        if isTyping, let key = Key(keyCode: event.keyCode) {
            let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            let modifierFlags = ModifierFlags(flags: flags)
            if modifierFlags != .empty {
                register(key: key, modifierFlags: modifierFlags)
                return true
            }
        }
        return isTyping
    }
    
    open override func flagsChanged(with event: NSEvent) {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        currentFlags = ModifierFlags(flags: flags)
        self.needsDisplay = true
        super.flagsChanged(with: event)
    }
    
    open override func keyDown(with event: NSEvent) {
        if !performKeyEquivalent(with: event) {
            super.keyDown(with: event)
        }
    }
    
    // Initializer
    public init(frame: NSRect, id: String? = nil) {
        self.id = id
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
        self.layer?.borderColor = CGColor(red: 0.69, green: 0.745, blue: 0.773, alpha: 1.0) //NSColor.gridColor.cgColor
        self.layer?.borderWidth = 1.0
        self.layer?.cornerRadius = 4.0
        
        let rect = NSRect(x: frame.width - 20.0,
                          y: 0.5 * (frame.height - 20.0),
                          width: 20.0,
                          height: 20.0)
        deleteButton = SpiceKeyDeleteButton(frame: rect)
        addSubview(deleteButton)
        deleteButton.target = self
        deleteButton.action = #selector(SpiceKeyField2.delete(_:))
        deleteButton.isEnabled = false
    }
    
    @IBAction func delete(_ sender: NSButton) {
        isEnabled = true
        currentFlags = nil
        currentKeyCombination = nil
        deleteButton.isEnabled = false
        self.needsDisplay = true
        delegate?.didDelete(self)
    }
    
    // Draw
    open override func drawFocusRingMask() {
        if isFirstResponder {
            let rectPath = NSBezierPath(roundedRect: self.bounds, xRadius: 4.0, yRadius: 4.0)
            rectPath.fill()
        }
    }
    
    open override func draw(_ dirtyRect: NSRect) {
//        super.draw(dirtyRect)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.baseWritingDirection = .leftToRight
        let textColor = isEnabled
            ? NSColor.labelColor
            : NSColor.secondaryLabelColor
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13.0),
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        let rect = CGRect(x: 2, y: 2, width: 60, height: 21)
        if let keyCombination = currentKeyCombination {
            NSString(string: keyCombination.string)
                .draw(in: rect, withAttributes: attributes)
            // これじゃダメ、やっぱりRECTじゃないと
        } else if let flags = currentFlags {
            NSString(string: flags.string)
                .draw(in: rect, withAttributes: attributes)
        }
    }
    
    // Focus/Unfocus
    private func focusField() -> Bool {
        if isEnabled {
            isTyping = true
            self.needsDisplay = true
            return true
        }
        return false
    }
    
    private func unfocusField() {
        isTyping = false
        self.needsDisplay = true
    }
    
    // Typing begin/end
    public func beginTyping() {
        if isEnabled, let window = self.window {
            if window.firstResponder != self || !isTyping {
                window.makeFirstResponder(self)
            }
        }
    }
    
    private func endTyping() {
        if let window = self.window, window.firstResponder == self || isTyping {
            window.makeFirstResponder(nil)
        }
    }
    
    private func register(key: Key, modifierFlags: ModifierFlags) {
        currentKeyCombination = KeyCombination(key, modifierFlags)
        isEnabled = false
        deleteButton.isEnabled = true
        endTyping()
        delegate?.didRegisterSpiceKey(self, currentKeyCombination!)
    }
    
//    open override func touchesBegan(with event: NSEvent) {
//        beginTyping()
//    }
    
}
