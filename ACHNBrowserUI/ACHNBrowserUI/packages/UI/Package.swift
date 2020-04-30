// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UI",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
    ],
    products: [
        .library(
            name: "UI",
            targets: ["UI"]),
    ],
    dependencies: [
        .package(path: "../Backend")
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: ["Backend"]),
        .testTarget(
            name: "UITests",
            dependencies: ["UI"]),
    ]
)
