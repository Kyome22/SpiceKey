/*
 WrappedSpiceKeyField.swift
 SpiceKey

 Created by Takuto Nakamura on 2022/07/04.
 Copyright © 2019 Takuto Nakamura. All rights reserved.
*/

import AppKit

public final class WrappedSpiceKeyField: NSView {
    let spiceKeyField: SpiceKeyField

    init(id: String? = nil) {
        spiceKeyField = SpiceKeyField(frame: .zero, id: id)
        super.init(frame: .zero)
        addSubview(spiceKeyField)

        spiceKeyField.translatesAutoresizingMaskIntoConstraints = false
        spiceKeyField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        spiceKeyField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        spiceKeyField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        spiceKeyField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
