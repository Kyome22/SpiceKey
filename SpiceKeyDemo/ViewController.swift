//
//  ViewController.swift
//  SpiceKeyDemo
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa
import SpiceKey

class ViewController: NSViewController {

    @IBOutlet weak var spiceKeyField1: SpiceKeyField!
    @IBOutlet weak var spiceKeyField2: SpiceKeyField!
    @IBOutlet weak var longPressPopup: NSPopUpButton!
    @IBOutlet weak var bothSidePopup: NSPopUpButton!
    @IBOutlet weak var stateLabel: NSTextField!
    private var spiceKey1: SpiceKey?
    private var spiceKey2: SpiceKey?
    private var longPress: Int = 0
    private var bothSide: Int = 0
    private var longPressSpiceKey: SpiceKey?
    private var bothSideSpiceKey: SpiceKey?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spiceKeyField1.delegate = self
        spiceKeyField2.delegate = self
        
        longPressSpiceKey = SpiceKey(ModifierFlags.ctrl, 1.0, modifierKeylongPressHandler: {
            self.stateLabel.stringValue = "Long Press"
        })
        longPressSpiceKey?.register()
        bothSideSpiceKey = SpiceKey(ModifierFlag.control, bothSideModifierKeysPressHandler: {
            self.stateLabel.stringValue = "Both Side"
        })
        bothSideSpiceKey?.register()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        spiceKey1?.unregister()
        spiceKey2?.unregister()
        longPressSpiceKey?.unregister()
        bothSideSpiceKey?.unregister()
    }

    override var representedObject: Any? {
        didSet {
        }
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

extension ViewController: SpiceKeyFieldDelegate {
    
    func didRegisterSpiceKey(_ field: SpiceKeyField, _ key: Key, _ flags: ModifierFlags) {
        if field === spiceKeyField1 {
            spiceKey1 = SpiceKey(KeyCombination(key, flags), keyDownHandler: {
                self.stateLabel.stringValue = "Hot-Key 1: keyDown"
            }, keyUpHandler: {
                self.stateLabel.stringValue = "Hot-Key 1: KeyUp"
            })
            spiceKey1?.register()
        } else if field === spiceKeyField2 {
            spiceKey2 = SpiceKey(KeyCombination(key, flags), keyDownHandler: {
                self.stateLabel.stringValue = "Hot-Key 2: keyDown"
            }, keyUpHandler: {
                self.stateLabel.stringValue = "Hot-Key 2: KeyUp"
            })
            spiceKey2?.register()
        }
    }
    
    func didDelete(_ field: SpiceKeyField) {
        if field === spiceKeyField1 {
            Swift.print("field 1")
            spiceKey1?.unregister()
        } else if field === spiceKeyField2 {
            Swift.print("field 2")
            spiceKey2?.unregister()
        }
    }
    
}
