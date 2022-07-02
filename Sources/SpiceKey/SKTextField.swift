//
//  SKTextField.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2022/06/29.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import SwiftUI
import Combine

public struct SKTextField: NSViewRepresentable {
    public typealias NSViewType = SpiceKeyField

    private let id: String?
    private let initialSpiceKey: SpiceKey?
    private var registeredHandler: ((String?, KeyCombination) -> Void)?
    private var deletedHandler: ((String?) -> Void)?

    public init(id: String? = nil, initialSpiceKey: SpiceKey? = nil) {
        self.id = id
        self.initialSpiceKey = initialSpiceKey
    }

    public func makeNSView(context: Context) -> SpiceKeyField {
        let textField = SpiceKeyField(frame: .zero)
        textField.delegate = context.coordinator
        textField.id = id
        if let initialSpiceKey = initialSpiceKey {
            textField.setInitialSpiceKey(initialSpiceKey)
            context.coordinator.innerIsEnabled = textField.isEnabled
        }
        return textField
    }

    public func updateNSView(_ nsView: SpiceKeyField, context: Context) {
        nsView.isEnabled = context.coordinator.innerIsEnabled
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
        var innerIsEnabled: Bool = true

        public init(_ parent: SKTextField) {
            self.parent = parent
        }

        public func didRegisterSpiceKey(_ field: SpiceKeyField, _ key: Key, _ flags: ModifierFlags) {
            guard parent.id == nil || parent.id! == field.id else { return }
            innerIsEnabled = field.isEnabled
            registeredHandler?(parent.id, KeyCombination(key, flags))
        }

        public func didDelete(_ field: SpiceKeyField) {
            guard parent.id == nil || parent.id! == field.id else { return }
            innerIsEnabled = field.isEnabled
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
