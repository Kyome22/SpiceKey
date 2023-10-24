/*
 SKTextField.swift
 SpiceKey

 Created by Takuto Nakamura on 2022/06/29.
 Copyright © 2019 Takuto Nakamura. All rights reserved.
*/

import SwiftUI
import Combine

public struct SKTextField: NSViewRepresentable {
    public typealias NSViewType = WrappedSpiceKeyField

    private let id: String?
    private let initialKeyCombo: KeyCombination?
    private var registeredHandler: ((String?, KeyCombination) -> Void)?
    private var deletedHandler: ((String?) -> Void)?

    public init(id: String? = nil, initialKeyCombination: KeyCombination? = nil) {
        self.id = id
        self.initialKeyCombo = initialKeyCombination
    }

    public func makeNSView(context: Context) -> WrappedSpiceKeyField {
        let view = WrappedSpiceKeyField(id: id)
        view.spiceKeyField.delegate = context.coordinator
        if let keyCombo = initialKeyCombo {
            view.spiceKeyField.setInitialKeyCombination(keyCombo)
        }
        return view
    }

    public func updateNSView(_ nsView: WrappedSpiceKeyField, context: Context) {
        context.coordinator.registeredHandler = registeredHandler
        context.coordinator.deletedHandler = deletedHandler
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    public class Coordinator: NSObject, SpiceKeyFieldDelegate {
        let parent: SKTextField
        var registeredHandler: ((String?, KeyCombination) -> Void)?
        var deletedHandler: ((String?) -> Void)?

        public init(_ parent: SKTextField) {
            self.parent = parent
        }

        public func didRegisterSpiceKey(_ field: SpiceKeyField, _ key: Key, _ flags: ModifierFlags) {
            guard parent.id == nil || parent.id! == field.id else { return }
            registeredHandler?(parent.id, KeyCombination(key, flags))
        }

        public func didDelete(_ field: SpiceKeyField) {
            guard parent.id == nil || parent.id! == field.id else { return }
            deletedHandler?(parent.id)
        }
    }

    public func onRegistered(perform action: @escaping (String?, KeyCombination) -> Void) -> SKTextField {
        var skTextField = self
        skTextField.registeredHandler = action
        return skTextField
    }

    public func onDeleted(perform action: @escaping (String?) -> Void) -> SKTextField {
        var skTextField = self
        skTextField.deletedHandler = action
        return skTextField
    }
}

struct SKTextField_Previews: PreviewProvider {
    static var previews: some View {
        SKTextField()
    }
}
