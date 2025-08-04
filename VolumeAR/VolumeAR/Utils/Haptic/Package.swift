// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Haptic",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Haptic",
            targets: ["Haptic"]
        )
    ],
    dependencies: [
        .package(name: "Protocols",path: "../../../Protocols"),
    ],
    targets: [
        .target(
            name: "Haptic",
            dependencies: [
                .product(name: "Protocols", package: "Protocols")
            ],
            path: "Sources/Haptic"
        ),
        .testTarget(
            name: "HapticTests",
            dependencies: ["Haptic"],
            path: "Tests/"
        )
    ]
)

