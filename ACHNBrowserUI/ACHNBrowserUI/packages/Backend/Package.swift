// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Backend",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Backend",
            targets: ["Backend"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI", from: "1.3.4"),
        .package(url: "https://github.com/jathu/UIImageColors", from: "2.2.0"),
        .package(name: "Purchases", url: "https://github.com/RevenueCat/purchases-ios", from: "3.2.2")
    ],
    targets: [
        .target(
            name: "Backend",
            dependencies: ["SDWebImageSwiftUI", "UIImageColors", "Purchases"]),
        .testTarget(
            name: "BackendTests",
            dependencies: ["Backend"]),
    ]
)
