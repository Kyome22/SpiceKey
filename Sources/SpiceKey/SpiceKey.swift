/*
 SpiceKey.swift
 SpiceKey

 Created by Takuto Nakamura on 2019/03/03.
 Copyright © 2019 Takuto Nakamura. All rights reserved.
*/

import Carbon

public typealias Handler = () async -> Void

public final class SpiceKey {
    internal let id: SpiceKeyID!
    internal var eventHotKey: EventHotKeyRef?
    internal var invoked: Bool = false
    public let keyCombination: KeyCombination?
    public let modifierFlags: ModifierFlags?
    public let keyDownHandler: Handler?
    public let keyUpHandler: Handler?
    public let bothModifierKeysPressHandler: Handler?
    public let modifierKeysLongPressHandler: Handler?
    public let releaseKeyHandler: Handler?

    public private(set) var interval: Double = 0.0
    public private(set) var isBothSide: Bool = false

    public init(
        _ keyCombination: KeyCombination,
        keyDownHandler: Handler? = nil,
        keyUpHandler: Handler? = nil
    ) {
        id = SpiceKeyManager.shared.generateID()
        self.keyCombination = keyCombination
        modifierFlags = nil
        self.keyDownHandler = keyDownHandler
        self.keyUpHandler = keyUpHandler
        bothModifierKeysPressHandler = nil
        modifierKeysLongPressHandler = nil
        releaseKeyHandler = nil
    }

    public init(
        _ modifierFlag: ModifierFlag,
        bothModifierKeysPressHandler: Handler? = nil,
        releaseKeyHandler: Handler? = nil
    ) {
        id = SpiceKeyManager.shared.generateID()
        keyCombination = nil
        modifierFlags = modifierFlag.flags
        keyDownHandler = nil
        keyUpHandler = nil
        self.bothModifierKeysPressHandler = bothModifierKeysPressHandler
        modifierKeysLongPressHandler = nil
        isBothSide = true
        self.releaseKeyHandler = releaseKeyHandler
    }

    public init?(
        _ modifierFlags: ModifierFlags,
        _ interval: Double,
        modifierKeysLongPressHandler: Handler? = nil,
        releaseKeyHandler: Handler? = nil
    ) {
        guard 0.0 < interval && interval <= 3.0 else { return nil }
        id = SpiceKeyManager.shared.generateID()
        keyCombination = nil
        self.modifierFlags = modifierFlags
        keyDownHandler = nil
        keyUpHandler = nil
        bothModifierKeysPressHandler = nil
        self.modifierKeysLongPressHandler = modifierKeysLongPressHandler
        self.interval = interval
        self.releaseKeyHandler = releaseKeyHandler
    }

    public func register() {
        SpiceKeyManager.shared.register(self)
    }

    public func unregister() {
        SpiceKeyManager.shared.unregister(self)
    }

    public var string: String {
        if let keyCombination = keyCombination {
            return keyCombination.string
        } else if let modifierFlags = modifierFlags {
            return modifierFlags.string
        } else {
            fatalError("Impossible")
        }
    }
}
