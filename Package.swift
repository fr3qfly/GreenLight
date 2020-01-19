// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "greenlight",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "greenlight", targets: ["App"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git",
        from: "0.5.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "GreenLight",
            dependencies: ["SPMUtility"]),
        .target(
            name: "App",
            dependencies: ["GreenLight"]),
        .testTarget(
            name: "GreenLightTests",
            dependencies: ["GreenLight"]),
    ]
)
