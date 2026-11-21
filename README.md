# SwiftUIBackports

SwiftUIBackports is a Swift package that brings newer SwiftUI APIs to older OS versions, enabling developers to use the latest SwiftUI features while maintaining compatibility with earlier iOS releases.

## Features
- Backported SwiftUI APIs: Utilize modern SwiftUI components on older iOS versions.
- Seamless Integration: Designed to integrate smoothly with existing SwiftUI projects.

## Installation

You can add SwiftUIBackports to your project using Swift Package Manager:
1. In Xcode, go to File > Add Packages…
2. Enter the repository URL: https://github.com/stalkermv/SwiftUIBackports
3. Choose the version you need.

Alternatively, add it directly to your Package.swift:

```
dependencies: [
    .package(url: "https://github.com/stalkermv/SwiftUIBackports.git", from: "2.0.0")
]
```

## Usage

Import SwiftUIBackports in your SwiftUI files:

```swift
import SwiftUI
import SwiftUIBackports
```

The backports use the same names as the native APIs. On OS versions that ship the native API the native one is used; elsewhere the backport takes over.

### Optional: SwiftUIIntrospect

The `onScrollGeometryChange` fallback on iOS 17 and `tabViewPageClipDisabled` need to reach into UIKit/AppKit views. They do this through [swiftui-introspect](https://github.com/siteline/swiftui-introspect), which is only linked when you enable the `useSwiftUIIntrospect` trait. Without the trait both still compile, but the iOS 17 `onScrollGeometryChange` fallback and `tabViewPageClipDisabled` have no effect. The trait has no effect on watchOS, where SwiftUIIntrospect is not available.

```swift
.package(
    url: "https://github.com/stalkermv/SwiftUIBackports.git",
    from: "2.0.0",
    traits: ["useSwiftUIIntrospect"]
)
```

### onScrollGeometryChange

Available on iOS, Mac Catalyst, tvOS and visionOS (not macOS or watchOS). Native on iOS 18 / tvOS 18 / visionOS 2.

```swift
struct HeaderExample: View {
    @State private var isScrolled = false

    var body: some View {
        ScrollView {
            // ...
        }
        .onScrollGeometryChange(for: Bool.self) { geometry in
            geometry.contentOffset.y > geometry.contentInsets.top
        } action: { _, isScrolled in
            self.isScrolled = isScrolled
        }
    }
}
```

### onScrollVisibilityChange

Native on iOS 18 / macOS 15 / tvOS 18 / watchOS 11 / visionOS 2. The fallback runs on iOS, Mac Catalyst and tvOS; on macOS 14 and watchOS 10 it does nothing.

```swift
Text("Video")
    .onScrollVisibilityChange(threshold: 0.5) { isVisible in
        isPlaying = isVisible
    }
```

### ForEach(subviews:) and Group(subviews:)

```swift
struct Card<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack {
            ForEach(subviews: content) { subview in
                subview.padding()
            }
        }
    }
}

struct Summary<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        Group(subviews: content) { subviews in
            Text("\(subviews.count) items")
            subviews.first
        }
    }
}
```

### Trait values, tags and ViewTree

`Subview.traitValues` reads the trait values and tag of a subview. `traitValue(_:_:)` sets a custom trait, and `ViewTree` exposes the children of a view directly.

```swift
struct BadgeKey: TraitValueKey {
    static let defaultValue = 0
}

extension TraitCollectionValues {
    var badge: Int { self[BadgeKey.self] }
}

struct BadgeList<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        ViewTree(content) { children in
            ForEach(children) { child in
                HStack {
                    child
                    Text("\(child.traitValues.badge)")
                    if child.traitValues.hasTag("selected") { Text("✓") }
                }
            }
        }
    }
}

BadgeList {
    Text("Inbox").traitValue(BadgeKey.self, 3).tag("selected")
    Text("Sent")
}
```

### tabViewPageClipDisabled

Requires the `useSwiftUIIntrospect` trait; applies to iOS and macOS.

```swift
TabView {
    Text("One")
    Text("Two")
}
.tabViewPageClipDisabled()
```

### DragGesture(allowedDirections:)

Lives in the separate `SwiftUIBackportsUnsafe` product; see [Migrating `DragGesture(allowedDirections:)`](#migrating-draggestureallowedirections).

## Compatibility

| Platform | Minimum |
|---|---|
| iOS | 17.0 |
| macOS | 14.0 |
| Mac Catalyst | 17.0 |
| tvOS | 17.0 |
| watchOS | 10.0 |
| visionOS | 2.0 |

Swift 6.1 or later. The optional `useSwiftUIIntrospect` trait enables the SwiftUIIntrospect-based code paths.

What 2.0 still provides:

- `onScrollGeometryChange` (native on iOS 18 / tvOS 18 / visionOS 2; fallback not available on watchOS)
- `onScrollVisibilityChange` (native on iOS 18 / macOS 15 / tvOS 18 / watchOS 11 / visionOS 2)
- `ForEach(subviews:)` and `Group(subviews:)` (native on iOS 18)
- `Subview.traitValues`, `tag(for:)`, `hasTag(_:)`, `traitValue(_:_:)`, `ViewTree`
- `tabViewPageClipDisabled(_:)`

## Migrating from 1.x

2.0 drops iOS 16 / macOS 13 and removes every backport whose native API is available at the new minimums. 1.2.0 marks all of them as deprecated, so build against 1.2.0 first and fix the warnings.

| Removed in 2.0 | Use instead |
|---|---|
| `onChange(of:initial:_:)` | native `onChange(of:initial:_:)` (iOS 17) |
| `safeAreaPadding(_:)` | native `safeAreaPadding` (iOS 17) |
| `contentMargins(_:_:for:)`, `ContentMarginPlacementBackport` | native `contentMargins` (iOS 17) |
| `containerRelativeFrame(...)` | native `containerRelativeFrame` (iOS 17) |
| `scrollTargetLayout()`, `scrollTargetBehavior(_:)`, `ScrollTargetBehaviorBackport` | native scroll target APIs (iOS 17) |
| `scrollPosition(id:anchor:)` | native `scrollPosition(id:anchor:)` (iOS 17) |
| `scrollClipDisabled(_:)` | native `scrollClipDisabled` (iOS 17) |
| `sensoryFeedback(...)`, `SensoryFeedbackBackport` | native `sensoryFeedback` (iOS 17) |
| `invalidatableContent(_:)`, `RedactionReasons.invalidated` | native `invalidatableContent` (iOS 17) |
| `toolbarTitleDisplayMode(_:)`, `ToolbarTitleDisplayModeBackport` | native `toolbarTitleDisplayMode` (iOS 17) |
| `ContentUnavailableView` (backport) | native `ContentUnavailableView` (iOS 17) |
| `ShapeStyle.fill`, `FillShapeStyle`, `ShapeStyleBackport` | native `.fill` (iOS 17) |
| `presentationCornerRadius(_:)` | native (iOS 16.4) |
| `presentationBackgroundInteraction(_:)`, `PresentationBackgroundInteractionBackport`, `PresentationDetentReference` | native (iOS 16.4) |
| `presentationCompactAdaptation(_:)`, `PresentationAdaptationBackport` | native (iOS 16.4) |
| `Text(_:format:)` | native (iOS 15) |
| `selectionDisabled(_:)`, `traitValues.selectionDisabled` | native `selectionDisabled(_:)` (iOS 17 / macOS 14). The `traitValues.selectionDisabled` accessor and `SelectionDisabledTraitKey` are removed with no replacement |
| `DragGesture(minimumDistance:coordinateSpace:allowedDirections:)` | moved to the separate `SwiftUIBackportsUnsafe` product (not a backport of a public API) |

### Migrating `DragGesture(allowedDirections:)`

`DragGesture(minimumDistance:coordinateSpace:allowedDirections:)` wraps a non-public SwiftUI initializer rather than backporting a public OS API. Its previous `unsafeBitCast` implementation trapped on OS 27 (`SwiftUI.DragGesture` grew from 50 to 59 bytes). In 2.0 it lives in the separate `SwiftUIBackportsUnsafe` product, which now calls SwiftUI's own initializer, so it no longer depends on the layout of `DragGesture`. It is available on iOS, macOS, Mac Catalyst, watchOS and visionOS, and unavailable on tvOS, where `DragGesture` itself does not exist.

```swift
// Package.swift
.product(name: "SwiftUIBackportsUnsafe", package: "SwiftUIBackports")

// Source
import SwiftUIBackportsUnsafe

let swipe = DragGesture(minimumDistance: 10, coordinateSpace: .local, allowedDirections: .horizontal)
```

> **Experimental.** `SwiftUIBackportsUnsafe` links against a non-public SwiftUI symbol. It can break on any OS update, is not covered by semantic versioning, and is kept out of the main product so that apps which do not import it never link that symbol.

## Contributing

Contributions are welcome! If you have ideas for additional backports or improvements:
1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Submit a pull request with a clear description of your changes.

Please ensure your code adheres to the existing style and includes appropriate tests.

## License

SwiftUIBackports is released under the MIT License. See LICENSE for details.
