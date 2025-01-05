// swift-tools-version: 6.0

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
]

let package = Package(
    name: "SpiceKey",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SpiceKey",
            targets: ["SpiceKey"]
        )
    ],
    targets: [
        .target(
            name: "SpiceKey",
            resources: [.process("Resources")],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SpiceKeyTests",
            dependencies: ["SpiceKey"],
            swiftSettings: swiftSettings
        )
    ]
)
