// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppCore",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AppCore",
            targets: ["AppCore"]
        )
    ],
    dependencies: [
        .package(name: "VolumeEntities",path: "../VolumeEntities"),
        .package(name: "Protocols",path: "../Protocols"),
        .package(name: "SurfaceDetection",path: "../VolumeAR/Utils/SurfaceDetection"),
        .package(name: "MeasureScene",path: "../VolumeAR/Scenes/MeasureScene")
    ],
    targets: [
        .target(
            name: "AppCore",
            dependencies: [
                .product(name: "VolumeEntities", package: "VolumeEntities"),
                .product(name: "Protocols", package: "Protocols"),
                .product(name: "SurfaceDetection", package: "SurfaceDetection"),
                .product(name: "MeasureScene", package: "MeasureScene")
            ],
            path: "Sources/AppCore"
        )
    ]
)
