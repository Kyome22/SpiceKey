//
//  SpiceKey.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/03/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import AppKit
import Carbon

public typealias Handler = () -> Void

public final class SpiceKey {
    internal let uuid = UUID()
    public let keyCombination: KeyCombination
    public let keyDownHandler: Handler?
    public let keyUpHandler: Handler?
    public private(set) var eventHotKey: EventHotKeyRef?
    public private(set) var identifier: UInt32?
    
    public init(keyCombination: KeyCombination,
                keyDownHandler: Handler? = nil,
                keyUpHandler: Handler? = nil) {
        self.keyCombination = keyCombination
        self.keyDownHandler = keyDownHandler
        self.keyUpHandler = keyUpHandler
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
