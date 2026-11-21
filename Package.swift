// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIBackports",
    platforms: [.iOS(.v17), .macOS(.v14), .macCatalyst(.v17), .tvOS(.v17), .watchOS(.v10)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "SwiftUIBackports", targets: ["SwiftUIBackports"]),
        // Helpers that link against non-public SwiftUI symbols. Kept out of the main product
        // so they are only linked into apps that import them, and not covered by semver.
        .library(name: "SwiftUIBackportsUnsafe", targets: ["SwiftUIBackportsUnsafe"]),
    ],
    traits: [
        .trait(name: "useSwiftUIIntrospect")
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "26.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftUIBackports",
            dependencies: [
                "SwiftUIBackportModifiers",
                .product(
                    name: "SwiftUIIntrospect",
                    package: "swiftui-introspect",
                    condition: .when(traits: ["useSwiftUIIntrospect"])
                )
            ],
            swiftSettings: [
                .define("USE_SWIFTUI_INTROSPECT", .when(traits: ["useSwiftUIIntrospect"]))
            ]
        ),
        .target(
            name: "SwiftUIBackportModifiers",
            dependencies: [
                .product(
                    name: "SwiftUIIntrospect",
                    package: "swiftui-introspect",
                    condition: .when(traits: ["useSwiftUIIntrospect"])
                )
            ],
            swiftSettings: [
                .define("USE_SWIFTUI_INTROSPECT", .when(traits: ["useSwiftUIIntrospect"]))
            ]
        ),
        .target(name: "SwiftUIBackportsUnsafe"),
        .testTarget(
            name: "SwiftUIBackportsTests",
            dependencies: ["SwiftUIBackports"]
        ),
        .testTarget(
            name: "SwiftUIBackportsUnsafeTests",
            dependencies: ["SwiftUIBackportsUnsafe"]
        ),
    ]
)
