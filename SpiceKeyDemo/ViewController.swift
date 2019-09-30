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
    @IBOutlet weak var longPressPopup: NSPopUpButton!
    @IBOutlet weak var bothSidePopup: NSPopUpButton!
    @IBOutlet weak var stateLabel: NSTextField!
    private var longPress: Int = 0
    private var bothSide: Int = 0
    private var longPressSpiceKey: SpiceKey? = nil
    private var bothSideSpiceKey: SpiceKey? = nil
    
    var shortcuts = [(view: ShortcutTextView, shortcut: String, spiceKey: SpiceKey?)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shortcutTextView1.setFirst(vc: self, id: 1, isExisting: false)
        shortcutTextView2.setFirst(vc: self, id: 2, isExisting: false)
        shortcuts.append((view: shortcutTextView1, shortcut: "", spiceKey: nil))
        shortcuts.append((view: shortcutTextView2, shortcut: "", spiceKey: nil))
        longPressSpiceKey = SpiceKey(ModifierFlags.ctrl, 1.0, modifierKeylongPressHandler: {
            self.stateLabel.stringValue = "Long Press"
        })
        longPressSpiceKey?.register()
        bothSideSpiceKey = SpiceKey(ModifierFlag.control, bothSideModifierKeysPressHandler: {
            self.stateLabel.stringValue = "Both Side"
        })
        bothSideSpiceKey?.register()
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
        if shortcuts[id - 1].shortcut.replacingOccurrences(of: modifierFlags.string, with: "").isEmpty {
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

    @IBAction func longPressPopupChange(_ sender: NSPopUpButton) {
        if longPress != sender.indexOfSelectedItem {
            longPressSpiceKey?.unregister()
            var modifierFlags: ModifierFlags!
            switch sender.indexOfSelectedItem {
            case 0: modifierFlags = ModifierFlags.ctrl
            case 1: modifierFlags = ModifierFlags.opt
            case 2: modifierFlags = ModifierFlags.sft
            case 3: modifierFlags = ModifierFlags.cmd
            default: break
            }
            longPressSpiceKey = SpiceKey(modifierFlags, 1.0, modifierKeylongPressHandler: {
                self.stateLabel.stringValue = "Long Press"
            })
            longPressSpiceKey?.register()
        }
    }
    
    @IBAction func bothSidePopupChange(_ sender: NSPopUpButton) {
        if bothSide != sender.indexOfSelectedItem {
            bothSideSpiceKey?.unregister()
            var modifierFlag: ModifierFlag!
            switch sender.indexOfSelectedItem {
            case 0: modifierFlag = ModifierFlag.control
            case 1: modifierFlag = ModifierFlag.option
            case 2: modifierFlag = ModifierFlag.shift
            case 3: modifierFlag = ModifierFlag.command
            default: break
            }
            bothSideSpiceKey = SpiceKey(modifierFlag, bothSideModifierKeysPressHandler: {
                self.stateLabel.stringValue = "Both Side"
            })
            bothSideSpiceKey?.register()
        }
    }
    
}

