// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpiceKey",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "SpiceKey",
            targets: ["SpiceKey"]),
    ],
    targets: [
        .target(
            name: "SpiceKey",
            dependencies: []),
        .testTarget(
            name: "SpiceKeyTests",
            dependencies: ["SpiceKey"]),
    ]
)
