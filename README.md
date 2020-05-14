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
// run after 1 sec
let longPressSpiceKey = SpiceKey(ModifierFlag.command, 1.0, modifierKeyLongPressHandler: {
    // process
})
longPressSpiceKey?.register()
```

Set `press both side of ⌘` shortcut.

```swift
let bothSideSpiceKey = SpiceKey(ModifierFlag.command, bothSideModifierKeysPressHandler: {
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
// or
KeyCombination.string
```

- Unregister a shortcut

```swift
spiceKey.unregister()
```

- Save shortcut

```swift
let spiceKeyData = SpiceKeyData(_ primaryKey: String,
                                _ keyCode: CGKeyCode,  // Key.keyCode
                                _ control: Bool,       // ModifierFlags.containsControl
                                _ option: Bool,        // ModifierFlags.containsOption
                                _ shift: Bool,         // ModifierFlags.containsShift
                                _ command: Bool,       // ModifierFlags.containsCommand
                                _ spiceKey: SpiceKey)
// or
// ler spiceKeyData = SpiceKeyData(_ primaryKey: String,
//                                 _ keyCode: CGKeyCode,
//                                 _ modifierFlags: ModifierFlags,
//                                 _ spiceKey: SpiceKey)

do {
    let data = try NSKeyedArchiver.archivedData(withRootObject: spiceKeyData, 
                                                requiringSecureCoding: false)
    UserDefaults.standard.set(data, forKey: "spiceKeyData")
} catch {
    Swift.print(error)
}
```

- Load shortcut

```swift
guard let data = userDefaults.data(forKey: "spiceKeyData") else {
    return
}
do {
    let spiceKeyData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! SpiceKeyData
} catch {
    Swift.print(error)
}
```