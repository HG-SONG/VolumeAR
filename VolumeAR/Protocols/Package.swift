// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Protocols",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Protocols",
            targets: ["Protocols"]
        )
    ],
    dependencies: [
        .package(name: "VolumeEntities",path: "../VolumeEntities"),
    ],
    targets: [
        .target(
            name: "Protocols",
            dependencies: [
                .product(name: "VolumeEntities", package: "VolumeEntities")
            ],
            path: "Sources/Protocols"
        )
    ]
)
