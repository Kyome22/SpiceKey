# SpiceKey
Global Shortcuts for macOS written by Swift.

## Installation

For installation with [CocoaPods](http://cocoapods.org), simply add the following to your `Podfile`:

```ruby
pod 'SpiceKey'
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
let keyCombo = KeyCombination(key: key, modifierFlags: modifierFlags)
let spiceKey = SpiceKey(keyCombination: keyCombo, keyDownHandler: {
    // process (key down)
}) {
    // process (key up)
}
spiceKey.register()
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
