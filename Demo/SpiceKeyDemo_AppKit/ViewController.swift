/*
 ViewController.swift
 SpiceKeyDemo_AppKit

 Created by Takuto Nakamura on 2022/07/02.
*/

import Cocoa
import SpiceKey

final class ViewController: NSViewController {
    @IBOutlet weak var spiceKeyField: SpiceKeyField!
    @IBOutlet weak var bothSidePopUp: NSPopUpButton!
    @IBOutlet weak var longPressPopUp: NSPopUpButton!
    @IBOutlet weak var stateLabel: NSTextField!

    var keyComboSpiceKey: SpiceKey? = nil
    var bothSideSpiceKey: SpiceKey? = nil
    var longPressSpiceKey: SpiceKey? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        stateLabel.stringValue = "Stand-by"

        spiceKeyField.delegate = self

        bothSidePopUp.removeAllItems()
        var bothSideTitles: [String] = ["Please select"]
        bothSideTitles += ModifierFlag.allCases.map { modifierFlag in
            "\(modifierFlag.string) \(modifierFlag.title)"
        }
        bothSidePopUp.addItems(withTitles: bothSideTitles)
        bothSidePopUp.selectItem(at: 0)

        longPressPopUp.removeAllItems()
        var longPressTitles: [String] = ["Please select"]
        longPressTitles += ModifierFlags.allCases.compactMap { modifierFlags -> String? in
            if modifierFlags == .empty { return nil }
            return "\(modifierFlags.string) \(modifierFlags.title)"
        }
        longPressPopUp.addItems(withTitles: longPressTitles)
        longPressPopUp.selectItem(at: 0)
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.title = "SpiceKeyDemo_AppKit"
    }

    @IBAction func didChangeBothSide(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == 0 {
            bothSideSpiceKey?.unregister()
            stateLabel.stringValue = "Both Side: Unregistered"
        } else if let modifierFlag = ModifierFlag(rawValue: sender.indexOfSelectedItem - 1) {
            bothSideSpiceKey = SpiceKey(modifierFlag, bothModifierKeysPressHandler: {
                self.stateLabel.stringValue = "Both Side: Press"
            }, releaseKeyHandler: {
                self.stateLabel.stringValue = "Both Side: Release"
            })
            bothSideSpiceKey?.register()
            stateLabel.stringValue = "Both Side: Registered"
        }
    }

    @IBAction func didChangeLongPress(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == 0 {
            longPressSpiceKey?.unregister()
            stateLabel.stringValue = "Long Press: Unregistered"
        } else if let modifierFlags = ModifierFlags(rawValue: sender.indexOfSelectedItem) {
            longPressSpiceKey = SpiceKey(modifierFlags, 0.5, modifierKeysLongPressHandler: {
                self.stateLabel.stringValue = "Long Press: Press"
            }, releaseKeyHandler: {
                self.stateLabel.stringValue = "Long Press: Release"
            })
            longPressSpiceKey?.register()
            stateLabel.stringValue = "Long Press: Registered"
        }
    }
}

extension ViewController: SpiceKeyFieldDelegate {
    func didRegisterSpiceKey(_ field: SpiceKeyField, _ key: Key, _ flags: ModifierFlags) {
        guard field === spiceKeyField else { return }
        keyComboSpiceKey = SpiceKey(KeyCombination(key, flags), keyDownHandler: {
            self.stateLabel.stringValue = "Key Combo: Key Down"
        }, keyUpHandler: {
            self.stateLabel.stringValue = "Key Combo: Key Up"
        })
        keyComboSpiceKey?.register()
        stateLabel.stringValue = "Key Combo: Registered"
    }

    func didDelete(_ field: SpiceKeyField) {
        guard field === spiceKeyField else { return }
        keyComboSpiceKey?.unregister()
        stateLabel.stringValue = "Key Combo: Unregistered"
    }
}
