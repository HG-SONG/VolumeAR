// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MeasureScene",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MeasureScene",
            targets: ["MeasureScene"]
        )
    ],
    dependencies: [
        .package(name: "Protocols",path: "../../../Protocols"),
        .package(name: "VolumeUI",path: "../../../VolumeUI"),
        .package(name: "VolumeEntities",path: "../../../VolumeEntities"),
    ],
    targets: [
        .target(
            name: "MeasureScene",
            dependencies: [
                .product(name: "Protocols", package: "Protocols"),
                .product(name: "VolumeUI", package: "VolumeUI"),
                .product(name: "VolumeEntities", package: "VolumeEntities")
            ],
            path: "Sources/MeasureScene"
        )
    ]
)
