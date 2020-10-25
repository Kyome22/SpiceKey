//
//  SpiceKey.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Carbon

public typealias Handler = () -> Void

public final class SpiceKey {
    internal let id: SpiceKeyID!
    internal var eventHotKey: EventHotKeyRef?
    internal var invoked: Bool = false
    public let keyCombination: KeyCombination?
    public let modifierFlags: ModifierFlags?
    public let keyDownHandler: Handler?
    public let keyUpHandler: Handler?
    public let bothSideModifierKeysPressHandler: Handler?
    public let modifierKeyLongPressHandler: Handler?
    public let releaseKeyHandler: Handler?
    
    public private(set) var interval: Double = 0.0
    public private(set) var isBothSide: Bool = false
    
    public init(_ keyCombination: KeyCombination,
                keyDownHandler: Handler? = nil,
                keyUpHandler: Handler? = nil) {
        id = SpiceKeyManager.shared.generateID()
        self.keyCombination = keyCombination
        modifierFlags = nil
        self.keyDownHandler = keyDownHandler
        self.keyUpHandler = keyUpHandler
        bothSideModifierKeysPressHandler = nil
        modifierKeyLongPressHandler = nil
        releaseKeyHandler = nil
    }
    
    public init(_ modifierFlag: ModifierFlag,
                bothSideModifierKeysPressHandler: @escaping Handler,
                releaseKeyHandler: Handler? = nil) {
        id = SpiceKeyManager.shared.generateID()
        keyCombination = nil
        modifierFlags = modifierFlag.flags
        keyDownHandler = nil
        keyUpHandler = nil
        self.bothSideModifierKeysPressHandler = bothSideModifierKeysPressHandler
        modifierKeyLongPressHandler = nil
        isBothSide = true
        self.releaseKeyHandler = releaseKeyHandler
    }
    
    public init?(_ modifierFlag: ModifierFlag,
                 _ interval: Double,
                 modifierKeyLongPressHandler: @escaping Handler,
                 releaseKeyHandler: Handler? = nil) {
        if interval <= 0.0 || 3.0 < interval { return nil }
        id = SpiceKeyManager.shared.generateID()
        keyCombination = nil
        self.modifierFlags = modifierFlag.flags
        keyDownHandler = nil
        keyUpHandler = nil
        bothSideModifierKeysPressHandler = nil
        self.modifierKeyLongPressHandler = modifierKeyLongPressHandler
        self.interval = interval
        self.releaseKeyHandler = releaseKeyHandler
    }
    
    public func register() {
        SpiceKeyManager.shared.register(self)
    }
    
    public func unregister() {
        SpiceKeyManager.shared.unregister(self)
    }
}
