// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VolumeUI",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "VolumeUI",
            targets: ["VolumeUI"]
        )
    ],
    dependencies: [
        .package(name: "VolumeEntities",path: "../VolumeEntities"),
    ],
    targets: [
        .target(
            name: "VolumeUI",
            dependencies: [
                .product(name: "VolumeEntities", package: "VolumeEntities")
            ],
            path: "Sources/VolumeUI"
        )
    ]
)

