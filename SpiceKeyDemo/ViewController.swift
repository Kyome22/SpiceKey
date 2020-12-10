//
//  ViewController.swift
//  SpiceKeyDemo
//
//  Created by Takuto Nakamura on 2020/12/10.
//

import Cocoa
import SpiceKey

class ViewController: NSViewController {

    @IBOutlet weak var spiceKeyField: SpiceKeyField!
    @IBOutlet weak var bothSidePopUp: NSPopUpButton!
    @IBOutlet weak var longPressPopUp: NSPopUpButton!
    @IBOutlet weak var label: NSTextField!

    var spiceKeys = [SpiceKey?](repeating: nil, count: 3)
    var bothSideFlag = ModifierFlag(rawValue: 0)!
    var longPressFlags = ModifierFlags(rawValue: 2)!

    override func viewDidLoad() {
        super.viewDidLoad()

        spiceKeyField.delegate = self

        bothSidePopUp.selectItem(at: 0)
        longPressPopUp.selectItem(at: 1)

        // Set Both Side
        spiceKeys[1] = SpiceKey(bothSideFlag, bothModifierKeysPressHandler: {
            self.label.stringValue = "Both Side: Press"
        }, releaseKeyHandler: {
            self.label.stringValue = "Both Side: Release"
        })
        spiceKeys[1]?.register()

        // Set Long Press (Momentary)
        spiceKeys[2] = SpiceKey(longPressFlags, 0.5, modifierKeysLongPressHandler: {
            self.label.stringValue = "Long Press: Press"
        }, releaseKeyHandler: {
            self.label.stringValue = "Long Press: Release"
        })
        spiceKeys[2]?.register()

        label.stringValue = ""
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        for i in (0 ..< 3) {
            spiceKeys[i]?.unregister()
            spiceKeys[i] = nil
        }
    }

    @IBAction func changedBothSideModifierKey(_ sender: NSPopUpButton) {
        let modifierFlag = ModifierFlag(rawValue: sender.indexOfSelectedItem)!
        if modifierFlag == bothSideFlag { return }
        bothSideFlag = modifierFlag
        spiceKeys[1]?.unregister()
        spiceKeys[1] = SpiceKey(bothSideFlag, bothModifierKeysPressHandler: {
            self.label.stringValue = "Both Side: Press"
        }, releaseKeyHandler: {
            self.label.stringValue = "Both Side: Release"
        })
        spiceKeys[1]?.register()
    }

    @IBAction func changedLongPressModifierKeys(_ sender: NSPopUpButton) {
        let modifierFlags = ModifierFlags(rawValue: sender.indexOfSelectedItem + 1)!
        if modifierFlags == longPressFlags { return }
        longPressFlags = modifierFlags
        spiceKeys[2]?.unregister()
        spiceKeys[2] = SpiceKey(longPressFlags, 0.5, modifierKeysLongPressHandler: {
            self.label.stringValue = "Long Press: Press"
        }, releaseKeyHandler: {
            self.label.stringValue = "Long Press: Release"
        })
        spiceKeys[2]?.register()
    }

}

extension ViewController: SpiceKeyFieldDelegate {

    func didRegisterSpiceKey(_ field: SpiceKeyField, _ key: Key, _ flags: ModifierFlags) {
        guard field === spiceKeyField else { return }
        spiceKeys[0] = SpiceKey(KeyCombination(key, flags), keyDownHandler: {
            self.label.stringValue = "Hot-Key: key down"
        }, keyUpHandler: {
            self.label.stringValue = "Hot-Key: key up"
        })
        spiceKeys[0]?.register()
    }

    func didDelete(_ field: SpiceKeyField) {
        guard field === spiceKeyField else { return }
        spiceKeys[0]?.unregister()
        label.stringValue = "Delete Hot-Key"
    }

}
