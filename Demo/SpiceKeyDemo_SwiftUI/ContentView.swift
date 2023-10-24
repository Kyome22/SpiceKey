/*
 ContentView.swift
 SpiceKeyDemo_SwiftUI

 Created by Takuto Nakamura on 2022/06/29.
*/

import SwiftUI
import SpiceKey

struct ContentView: View {
    @State var state: String = "Stand-by"
    @State var bothSideSelection: ModifierFlag? = nil
    @State var longPressSelection: ModifierFlags? = nil
    @State var keyComboSpiceKey: SpiceKey? = nil
    @State var bothSideSpiceKey: SpiceKey? = nil
    @State var longPressSpiceKey: SpiceKey? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                Text("Key Combo:")
                SKTextField(id: "sample")
                    .onRegistered { (id, keyCombination) in
                        keyComboSpiceKey = SpiceKey(keyCombination, keyDownHandler: {
                            state = "Key Combo: Key Down"
                        }, keyUpHandler: {
                            state = "Key Combo: Key Up"
                        })
                        keyComboSpiceKey?.register()
                        state = "Key Combo: Registered"
                    }
                    .onDeleted { id in
                        keyComboSpiceKey?.unregister()
                        state = "Key Combo: Unregistered"
                    }
            }
            Picker("Both Side:", selection: $bothSideSelection) {
                Text("Please select")
                    .tag(ModifierFlag?(nil))
                ForEach(ModifierFlag.allCases, id: \.rawValue) { modifierFlag in
                    Text("\(modifierFlag.string) \(modifierFlag.title)")
                        .tag(ModifierFlag?.some(modifierFlag))
                }
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
            Picker("Long Press:", selection: $longPressSelection) {
                Text("Please select")
                    .tag(ModifierFlags?(nil))
                ForEach(Array(ModifierFlags.allCases.dropFirst()), id: \.rawValue) { modifierFlags in
                    Text("\(modifierFlags.string) \(modifierFlags.title)")
                        .tag(ModifierFlags?.some(modifierFlags))
                }
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
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("State:")
                Text(state)
            }
        }
        .frame(width: 300)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
