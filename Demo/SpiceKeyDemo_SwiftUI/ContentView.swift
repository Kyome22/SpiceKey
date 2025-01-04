/*
 ContentView.swift
 SpiceKeyDemo_SwiftUI

 Created by Takuto Nakamura on 2022/06/29.
*/

import SwiftUI
import SpiceKey

struct ContentView: View {
    @State private var state: String = "Stand-by"
    @State private var keyCombination: KeyCombination?
    @State private var bothSideSelection: ModifierFlag?
    @State private var longPressSelection: ModifierFlags?
    @State private var keyComboSpiceKey: SpiceKey?
    @State private var bothSideSpiceKey: SpiceKey?
    @State private var longPressSpiceKey: SpiceKey?

    var body: some View {
        Form {
            LabeledContent {
                SpiceKeyField(keyCombination: $keyCombination)
                    .onChange(of: keyCombination) { newValue in
                        if let keyCombination = newValue {
                            keyComboSpiceKey = SpiceKey(keyCombination, keyDownHandler: {
                                state = "Key Combo: Key Down"
                            }, keyUpHandler: {
                                state = "Key Combo: Key Up"
                            })
                            keyComboSpiceKey?.register()
                            state = "Key Combo: Registered"
                        } else {
                            keyComboSpiceKey?.unregister()
                            state = "Key Combo: Unregistered"
                        }
                    }
            } label: {
                Text("Key Combo:")
            }
            Picker(selection: $bothSideSelection) {
                Text("Please select")
                    .tag(ModifierFlag?.none)
                ForEach(ModifierFlag.allCases, id: \.rawValue) { modifierFlag in
                    Text("\(modifierFlag.string) \(modifierFlag.title)")
                        .tag(ModifierFlag?.some(modifierFlag))
                }
            } label: {
                Text("Both Side:")
            }
            .onChange(of: bothSideSelection) { newValue in
                if let modifierFlag = newValue {
                    bothSideSpiceKey = SpiceKey(modifierFlag, bothModifierKeysPressHandler: {
                        state = "Both Side: Press"
                    }, releaseKeyHandler: {
                        state = "Both Side: Release"
                    })
                    bothSideSpiceKey?.register()
                    state = "Both Side: Registered"
                } else {
                    bothSideSpiceKey?.unregister()
                    state = "Both Side: Unregistered"
                }
            }
            Picker(selection: $longPressSelection) {
                Text("Please select")
                    .tag(ModifierFlags?.none)
                ForEach(Array(ModifierFlags.allCases.dropFirst()), id: \.rawValue) { modifierFlags in
                    Text("\(modifierFlags.string) \(modifierFlags.title)")
                        .tag(ModifierFlags?.some(modifierFlags))
                }
            } label: {
                Text("Long Press:")
            }
            .onChange(of: longPressSelection) { newValue in
                if let modifierFlags = newValue {
                    longPressSpiceKey = SpiceKey(modifierFlags, 0.5, modifierKeysLongPressHandler: {
                        state = "Long Press: Press"
                    }, releaseKeyHandler: {
                        state = "Long Press: Release"
                    })
                    longPressSpiceKey?.register()
                    state = "Long Press: Registered"
                } else {
                    longPressSpiceKey?.unregister()
                    state = "Long Press: Unregistered"
                }
            }
            Divider()
            LabeledContent {
                Text(state)
            } label: {
                Text("State:")
            }
        }
        .frame(width: 300)
        .fixedSize()
        .padding()
    }
}

#Preview {
    ContentView()
}
