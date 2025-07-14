// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Touchy",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Touchy",
            targets: ["Touchy"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        .target(
            name: "Touchy",
            dependencies: [],
            path: "Sources/Touchy",
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS]))
            ]),
        .testTarget(
            name: "TouchyTests",
            dependencies: ["Touchy"],
            path: "Tests/TouchyTests",
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS]))
            ]),
    ]
)
