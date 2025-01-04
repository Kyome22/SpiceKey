/*
 SpiceKeyField.swift
 SpiceKey

 Created by Takuto Nakamura on 2022/06/29.
 Copyright © 2019 Takuto Nakamura. All rights reserved.
*/

import SwiftUI
import Combine

public struct SpiceKeyField: NSViewRepresentable {
    @Binding private var keyCombination: KeyCombination?

    public init(keyCombination: Binding<KeyCombination?>) {
        _keyCombination = keyCombination
    }

    public func makeNSView(context: Context) -> RawSpiceKeyField {
        let spiceKeyField = RawSpiceKeyField(frame: .zero)
        spiceKeyField.delegate = context.coordinator
        if let keyCombination {
            spiceKeyField.setKeyCombination(keyCombination)
        }
        return spiceKeyField
    }

    public func updateNSView(_ spiceKeyField: RawSpiceKeyField, context: Context) {
        if let keyCombination {
            spiceKeyField.setKeyCombination(keyCombination)
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, RawSpiceKeyFieldDelegate {
        let parent: SpiceKeyField
        var registeredHandler: ((String?, KeyCombination) -> Void)?
        var deletedHandler: ((String?) -> Void)?

        public init(_ parent: SpiceKeyField) {
            self.parent = parent
        }

        public func didRegisterSpiceKey(_ field: RawSpiceKeyField, _ key: Key, _ flags: ModifierFlags) {
            parent.keyCombination = KeyCombination(key, flags)
        }

        public func didDelete(_ field: RawSpiceKeyField) {
            parent.keyCombination = nil
        }
    }
}
