# SpiceKey
Global Shortcuts for macOS written in Swift.

## Installation

### CocoaPods
```
pod 'SpiceKey'
```

### Carthage
```
github "Kyome22/SpiceKey"
```

## Demo
Demo App is in this Project.

![image](https://github.com/Kyome22/SpiceKey/blob/master/images/DemoApp.png)


## Usage

- Register a shortcut

Set `⌘ + A` shortcut.

```swift
let key = Key.a
let modifierFlags = ModifierFlags.cmd
let keyCombo = KeyCombination(key, modifierFlags)
let spiceKey = SpiceKey(keyCombo, keyDownHandler: {
    // process (key down)
}) {
    // process (key up)
}
spiceKey.register()
```

Set `long press ⌘` shortcut.

```swift
let longPressSpiceKey = SpiceKey(ModifierFlags.ctrl, 1.0, modifierKeylongPressHandler: {
    // process
})
longPressSpiceKey?.register()       
```

Set `press both side of ⌘` shortcut.

```swift
let bothSideSpiceKey = SpiceKey(ModifierFlag.control, bothSideModifierKeysPressHandler: {
    // process
})
bothSideSpiceKey?.register()
```

- Create a Key and a ModifierFlags from NSEvent.

```swift
func example(event: NSEvent) {
    let key = Key(keyCode: event.keyCode)
    let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
    let modifierFlags = ModifierFlags(flags: flags)
}
```

- Get a description of the shortcut

```swift
let description = modifierFlags.string + key.string
```

- Unregister a shortcut

```swift
spiceKey.unregister()
```
