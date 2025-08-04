// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Leveling",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Leveling",
            targets: ["Leveling"]
        )
    ],
    dependencies: [
        .package(name: "Protocols",path: "../../../Protocols"),
    ],
    targets: [
        .target(
            name: "Leveling",
            dependencies: [
                .product(name: "Protocols", package: "Protocols")
            ],
            path: "Sources/Leveling"
        )
//        .testTarget(
//                    name: "SurfaceDetectionTests",
//                    dependencies: ["SurfaceDetection"],
//                    path: "Tests/"
//                )
    ]
)
