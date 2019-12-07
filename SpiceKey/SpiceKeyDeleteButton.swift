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
                image = NSImage(imageLiteralResourceName: "deleteOn")
            } else {
                image = NSImage(imageLiteralResourceName: "arrow")
                image?.isTemplate = true
            }
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        isBordered = false
        wantsLayer = true
        image = NSImage(imageLiteralResourceName: "deleteOn")
        alternateImage = NSImage(imageLiteralResourceName: "deleteOff")
        imagePosition = NSButton.ImagePosition.imageOnly
        imageScaling = NSImageScaling.scaleProportionallyDown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
