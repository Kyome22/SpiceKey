/*
 SpiceKeyDeleteButton.swift
 SpiceKey

 Created by Takuto Nakamura on 2019/12/08.
 Copyright © 2019 Takuto Nakamura. All rights reserved.
*/

import AppKit

public class SpiceKeyDeleteButton: NSButton {
    override public var isEnabled: Bool {
        didSet {
            if isEnabled {
                image = bundleImage(name: "delete")
            } else {
                image = bundleImage(name: "arrow")
            }
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setButtonType(NSButton.ButtonType.momentaryChange)
        image = bundleImage(name: "delete")
        alternateImage = bundleImage(name: "delete_alt")
        imagePosition = NSButton.ImagePosition.imageOnly
        imageScaling = NSImageScaling.scaleProportionallyDown
        isBordered = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bundleImage(name: String) -> NSImage? {
        return Bundle.module.image(forResource: name)
    }
}
