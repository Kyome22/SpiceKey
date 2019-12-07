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
                image = Bundle(for: SpiceKeyDeleteButton.self).image(forResource: "deleteOn")
            } else {
                image = Bundle(for: SpiceKeyDeleteButton.self).image(forResource: "arrow")
                image?.isTemplate = true
            }
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        isBordered = false
        wantsLayer = true
        image = Bundle(for: SpiceKeyDeleteButton.self).image(forResource: "deleteOn")
        alternateImage = Bundle(for: SpiceKeyDeleteButton.self).image(forResource: "deleteOff")
        imagePosition = NSButton.ImagePosition.imageOnly
        imageScaling = NSImageScaling.scaleProportionallyDown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
