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
    internal let uuid = UUID()
    public let keyCombination: KeyCombination?
    public let modifierFlags: ModifierFlags?
    public let keyDownHandler: Handler?
    public let keyUpHandler: Handler?
    public let bothSideModifierKeysPressHandler: Handler?
    public let modifierKeyLongPressHandler: Handler?
    
    public private(set) var eventHotKey: EventHotKeyRef?
    public private(set) var identifier: UInt32?
    public private(set) var interval: Double = 0.0
    public private(set) var isBothSide: Bool = false
    
    public init(_ keyCombination: KeyCombination,
                keyDownHandler: Handler? = nil,
                keyUpHandler: Handler? = nil) {
        self.keyCombination = keyCombination
        modifierFlags = nil
        self.keyDownHandler = keyDownHandler
        self.keyUpHandler = keyUpHandler
        bothSideModifierKeysPressHandler = nil
        modifierKeyLongPressHandler = nil
    }
    
    public init(_ modifierFlag: ModifierFlag,
                bothSideModifierKeysPressHandler: @escaping Handler) {
        keyCombination = nil
        modifierFlags = modifierFlag.flags
        keyDownHandler = nil
        keyUpHandler = nil
        self.bothSideModifierKeysPressHandler = bothSideModifierKeysPressHandler
        modifierKeyLongPressHandler = nil
        isBothSide = true
    }
    
    public init?(_ modifierFlags: ModifierFlags,
                _ interval: Double,
                modifierKeylongPressHandler: @escaping Handler) {
        if interval <= 0.0 || 3.0 < interval {
            return nil
        }
        keyCombination = nil
        self.modifierFlags = modifierFlags
        keyDownHandler = nil
        keyUpHandler = nil
        bothSideModifierKeysPressHandler = nil
        self.modifierKeyLongPressHandler = modifierKeylongPressHandler
        self.interval = interval
    }

    internal func setting(_ eventHotKey: EventHotKeyRef, _ identifier: UInt32) {
        self.eventHotKey = eventHotKey
        self.identifier = identifier
    }
    
    public func register() {
        SpiceKeyManager.shared.register(self)
    }
    
    public func unregister() {
        SpiceKeyManager.shared.unregister(self)
    }
}
