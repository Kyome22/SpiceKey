//
//  ShortcutTextView.swift
//  SpiceKeyDemo
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

protocol ShortcutTextViewDelegate: AnyObject {
    func didPressKey(_ id: Int, _ event: NSEvent)
    func didChangeFlag(_ id: Int, _ event: NSEvent)
    func didPushDelete(_ id: Int)
    func onFocus(_ id: Int)
}

class ShortcutTextView: NSView {
    
    weak var delegate: ShortcutTextViewDelegate?
    var nameField: NSTextField!
    var shortcutField: ShortcutField!
    var deleteBtn: NSButton!
    var monitors = [Any?]()
    var isExisting: Bool = false
    var isSelected: Bool = false {
        didSet {
            self.layer?.backgroundColor = NSColor(hex: isSelected ? "0277BD" : "455A64").cgColor
        }
    }
    var id: Int = 0
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor(hex: "455A64").cgColor
        
        nameField = NSTextField(frame: NSRect(x: 1, y: 1, width: 70, height: frame.height - 2))
        nameField.isSelectable = false
        nameField.isEditable = false
        addSubview(nameField)
        
        shortcutField = ShortcutField(frame: NSRect(x: 75, y: 1, width: frame.width - 75, height: frame.height - 2))
        addSubview(shortcutField)
        
        deleteBtn = NSButton(frame: NSRect(x: frame.width - 19, y: 2, width: 16, height: 16))
        deleteBtn.wantsLayer = true
        deleteBtn.isBordered = false
        deleteBtn.image = NSImage(imageLiteralResourceName: "deleteOff")
        deleteBtn.imagePosition = NSButton.ImagePosition.imageOnly
        deleteBtn.imageScaling = NSImageScaling.scaleProportionallyDown
        addSubview(deleteBtn)
        deleteBtn.target = self
        deleteBtn.action = #selector(self.pushBtn(_:))
        
        setMonitors()
    }
    
    deinit {
        for monitor in monitors {
            NSEvent.removeMonitor(monitor!)
        }
        monitors.removeAll()
    }
    
    func setMonitors() {
        monitors.append(NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { (event) -> NSEvent? in
            if !self.isExisting && self.isSelected {
                let flags = event.modifierFlags.intersection(NSEvent.ModifierFlags.deviceIndependentFlagsMask)
                if flags.contains(.shift) || flags.contains(.control) || flags.contains(.option) || flags.contains(.command) {
                    self.delegate?.didPressKey(self.id, event)
                }
            }
            return event
        }))
        monitors.append(NSEvent.addLocalMonitorForEvents(matching: .flagsChanged, handler: { (event) -> NSEvent? in
            if !self.isExisting && self.isSelected {
                self.delegate?.didChangeFlag(self.id, event)
            }
            return event
        }))
    }
    
    func setFirst(vc: ViewController, id: Int, isExisting: Bool) {
        self.delegate = vc
        self.id = id
        self.isExisting = isExisting
        self.nameField.stringValue = "Shortcut \(id)"
    }
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.onFocus(id)
    }
    
    @objc func pushBtn(_ sender: Any) {
        delegate?.didPushDelete(id)
    }
    
    func setLabel(shortcut: String) {
        shortcutField.stringValue = shortcut
        if isExisting {
            deleteBtn.isEnabled = true
            deleteBtn.image = NSImage(imageLiteralResourceName: "deleteOn")
        } else {
            deleteBtn.isEnabled = false
            if isSelected {
                deleteBtn.image = NSImage(imageLiteralResourceName: "arrow")
                let currentMode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
                deleteBtn.image?.isTemplate = (currentMode == "Dark")
            } else {
                deleteBtn.image = NSImage(imageLiteralResourceName: "deleteOff")
            }
        }
    }
    
}
