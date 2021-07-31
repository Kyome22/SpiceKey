//
//  File.swift
//  
//
//  Created by Takuto Nakamura on 2021/08/01.
//

import Cocoa

public protocol SpiceKeyField2Delegate: AnyObject {
    func didRegisterSpiceKey(_ field: SpiceKeyField2, _ key: Key, _ flags: ModifierFlags)
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
            
        }
    }
    
    public private(set) var isTyping = false
    
    private var isFirstResponder: Bool {
        return (isEnabled && isTyping && self.window?.firstResponder == self)
    }
    
    open override var isOpaque: Bool {
        return false
    }
    
    open override var focusRingMaskBounds: NSRect {
        return self.isFirstResponder ? self.bounds : .zero
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
        deleteButton.isEnabled = false
        delegate?.didDelete(self)
    }
    
    open override func drawFocusRingMask() {
        if isFirstResponder {
            let rectPath = NSBezierPath(roundedRect: self.bounds, xRadius: 4.0, yRadius: 4.0)
            rectPath.fill()
        }
    }
    
    open override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.baseWritingDirection = .leftToRight
        let textColor = isEnabled
            ? NSColor.labelColor.cgColor
            : NSColor.secondaryLabelColor.cgColor
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13.0),
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        if let keyCombination = currentKeyCombination {
            NSString(string: keyCombination.string)
                .draw(at: CGPoint(x: 2, y: 2), withAttributes: attributes)
        } else if let flags = currentFlags {
            NSString(string: flags.string)
                .draw(at: CGPoint(x: 2, y: 2), withAttributes: attributes)
        }
    }
    
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
}
