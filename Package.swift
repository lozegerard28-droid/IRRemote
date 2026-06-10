// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "IRRemote",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "IRRemote",
            targets: ["IRRemote"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.0")
    ],
    targets: [
        .target(
            name: "IRRemote",
            dependencies: [
                .product(name: "ZIPFoundation", package: "ZIPFoundation")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "IRRemoteTests",
            dependencies: ["IRRemote"]
        ),
    ]
)
