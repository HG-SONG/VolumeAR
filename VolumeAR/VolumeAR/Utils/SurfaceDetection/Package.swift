// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SurfaceDetection",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SurfaceDetection",
            targets: ["SurfaceDetection"]
        )
    ],
    dependencies: [
        .package(name: "Protocols",path: "../../../Protocols"),
    ],
    targets: [
        .target(
            name: "SurfaceDetection",
            dependencies: [
                .product(name: "Protocols", package: "Protocols")
            ],
            path: "Sources/SurfaceDetection"
        )
    ]
)
