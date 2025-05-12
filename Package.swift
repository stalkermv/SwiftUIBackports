// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIBackports",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "SwiftUIBackports", targets: ["SwiftUIBackports"]),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect.git", from: "1.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftUIBackports",
            dependencies: ["SwiftUIBackportModifiers"]
        ),
        .target(
            name: "SwiftUIBackportModifiers",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect")
            ]
        ),
        .testTarget(
            name: "SwiftUIBackportsTests",
            dependencies: ["SwiftUIBackports"]
        ),
    ]
)
