// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EMTiMMemory",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "EMTiMMemory",
            targets: ["EMTiMMemory"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // No external dependencies for now - keeping it lightweight
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        .target(
            name: "EMTiMMemory",
            dependencies: []),
        .testTarget(
            name: "EMTiMMemoryTests",
            dependencies: ["EMTiMMemory"]),
    ]
) 