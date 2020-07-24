// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MBAdminSwift",
    platforms: [.iOS(.v11)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MBAdminSwift",
            targets: ["MBAdminSwift"])

    ],
    dependencies: [
        .package(url: "https://github.com/Mumble-SRL/MBurgerSwift.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MBAdminSwift",
            dependencies: ["MBurgerSwift"],
            path: "MBAdminSwift"
        ),
        .testTarget(
            name: "MBAdminSwiftTests",
            dependencies: ["MBAdminSwift"],
            path: "MBAdminSwiftTests")
    ]
)
