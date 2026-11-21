// swift-tools-version: 6.1

import PackageDescription

// SwiftUIIntrospect does not build for watchOS, so the trait has no effect there.
let introspectPlatforms: [Platform] = [.iOS, .macOS, .macCatalyst, .tvOS, .visionOS]

let package = Package(
    name: "SwiftUIBackports",
    platforms: [.iOS(.v17), .macOS(.v14), .macCatalyst(.v17), .tvOS(.v17), .watchOS(.v10), .visionOS(.v2)],
    products: [
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
        .target(
            name: "SwiftUIBackports",
            dependencies: [
                "SwiftUIBackportModifiers",
                .product(
                    name: "SwiftUIIntrospect",
                    package: "swiftui-introspect",
                    condition: .when(platforms: introspectPlatforms, traits: ["useSwiftUIIntrospect"])
                )
            ],
            swiftSettings: [
                .define("USE_SWIFTUI_INTROSPECT", .when(platforms: introspectPlatforms, traits: ["useSwiftUIIntrospect"]))
            ]
        ),
        .target(
            name: "SwiftUIBackportModifiers",
            dependencies: [
                .product(
                    name: "SwiftUIIntrospect",
                    package: "swiftui-introspect",
                    condition: .when(platforms: introspectPlatforms, traits: ["useSwiftUIIntrospect"])
                )
            ],
            swiftSettings: [
                .define("USE_SWIFTUI_INTROSPECT", .when(platforms: introspectPlatforms, traits: ["useSwiftUIIntrospect"]))
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
