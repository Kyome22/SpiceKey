// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "SpiceKey",
    platforms: [
        .macOS(.v11)
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
            resources: [.copy("PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "SpiceKeyTests",
            dependencies: ["SpiceKey"]
        )
    ]
)
