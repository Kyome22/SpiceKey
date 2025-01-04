// swift-tools-version:5.10

import PackageDescription

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
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SpiceKeyTests",
            dependencies: ["SpiceKey"]
        )
    ]
)
