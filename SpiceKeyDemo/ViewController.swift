//
//  ViewController.swift
//  SpiceKeyDemo
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa
import SpiceKey

class ViewController: NSViewController, ShortcutTextViewDelegate {

    @IBOutlet weak var shortcutTextView1: ShortcutTextView!
    @IBOutlet weak var shortcutTextView2: ShortcutTextView!
    @IBOutlet weak var stateLabel: NSTextField!
    
    var shortcuts = [(view: ShortcutTextView, shortcut: String, spiceKey: SpiceKey?)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shortcutTextView1.setFirst(vc: self, id: 1, isExisting: false)
        shortcutTextView2.setFirst(vc: self, id: 2, isExisting: false)
        shortcuts.append((view: shortcutTextView1, shortcut: "", spiceKey: nil))
        shortcuts.append((view: shortcutTextView2, shortcut: "", spiceKey: nil))
    }

    override var representedObject: Any? {
        didSet {
        }
    }

    func didPressKey(_ id: Int, _ event: NSEvent) {
        let flags = event.modifierFlags.intersection(NSEvent.ModifierFlags.deviceIndependentFlagsMask)
        guard let key = Key(keyCode: event.keyCode), let modifierFlags = ModifierFlags(flags: flags) else {
            return
        }
        
        if modifierFlags.string == "" {
            shortcuts[id - 1].shortcut = modifierFlags.string
            shortcuts[id - 1].view.setLabel(shortcut: shortcuts[id - 1].shortcut)
            return
        }
        if shortcuts[id - 1].shortcut.replacingOccurrences(of: modifierFlags.string, with: "").count == 0 {
            let spiceKey = SpiceKey(KeyCombination(key, modifierFlags), keyDownHandler: {
                self.stateLabel.stringValue = "Shortcut: \(id), down"
            }) {
                self.stateLabel.stringValue = "Shortcut: \(id), up"
            }
            spiceKey.register()
            shortcuts[id - 1].spiceKey = spiceKey
            shortcuts[id - 1].shortcut += key.string
            shortcuts[id - 1].view.isExisting = true
            shortcuts[id - 1].view.setLabel(shortcut: shortcuts[id - 1].shortcut)
        } else {
            shortcuts[id - 1].view.setLabel(shortcut: shortcuts[id - 1].shortcut)
        }
    }
    
    func didChangeFlag(_ id: Int, _ event: NSEvent) {
        let flags = event.modifierFlags.intersection(NSEvent.ModifierFlags.deviceIndependentFlagsMask)
        guard let modifierFlags = ModifierFlags(flags: flags) else {
            shortcuts[id - 1].shortcut = ""
            shortcuts[id - 1].view.setLabel(shortcut: shortcuts[id - 1].shortcut)
            return
        }
        shortcuts[id - 1].shortcut = modifierFlags.string
        shortcuts[id - 1].view.setLabel(shortcut: shortcuts[id - 1].shortcut)
    }
    
    func didPushDelete(_ id: Int) {
        shortcuts[id - 1].spiceKey?.unregister()
        shortcuts[id - 1].view.isExisting = false
        shortcuts[id - 1].shortcut = ""
        shortcuts[id - 1].view.setLabel(shortcut: "")
    }
    
    func onFocus(_ id: Int) {
        shortcutTextView1.isSelected = (id == 1)
        shortcutTextView1.setLabel(shortcut: shortcuts[0].shortcut)
        shortcutTextView2.isSelected = (id == 2)
        shortcutTextView2.setLabel(shortcut: shortcuts[1].shortcut)
    }

}

