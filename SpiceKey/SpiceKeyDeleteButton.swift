//
//  SpiceKeyDeleteButton.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/12/08.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

public class SpiceKeyDeleteButton: NSButton {
    
    override public var isEnabled: Bool {
        didSet {
            if isEnabled {
                image = bundleImage(name: "delete")
            } else {
                image = bundleImage(name: "arrow")
                image?.isTemplate = true
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
        var bundle = Bundle(identifier: "com.kyome.SpiceKey")
        if bundle == nil {
            bundle = Bundle(for: SpiceKeyDeleteButton.self)
        }
        return bundle?.image(forResource: NSImage.Name(name))
    }
    
}
