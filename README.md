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
import SwiftUIBackports
```

Then, use the backported APIs as you would normally. For example:

```swift
// Example usage of a backported API
```


## Compatibility

| Platform | Minimum |
|---|---|
| iOS | 17.0 |
| macOS | 14.0 |
| Mac Catalyst | 17.0 |
| tvOS | 17.0 |
| watchOS | 10.0 |

Swift 6.1 or later. The optional `useSwiftUIIntrospect` trait enables the SwiftUIIntrospect-based code paths.

What 2.0 still provides:

- `onScrollGeometryChange` (native on iOS 18; fallback not available on watchOS)
- `onScrollVisibilityChange` (native on iOS 18 / macOS 15 / tvOS 18 / watchOS 11)
- `ForEach(subviews:)` and `Group(subviews:)` (native on iOS 18)
- `Subview.traitValues`, `tag(for:)`, `hasTag(_:)`, `traitValue(_:_:)`, `ViewTree`
- `selectionDisabled(_:)` together with `traitValues.selectionDisabled`
- `tabViewPageClipDisabled(_:)`
- `DragGesture(minimumDistance:coordinateSpace:allowedDirections:)` (not on tvOS)

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

## Contributing

Contributions are welcome! If you have ideas for additional backports or improvements:
1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Submit a pull request with a clear description of your changes.

Please ensure your code adheres to the existing style and includes appropriate tests.

## License

SwiftUIBackports is released under the MIT License. See LICENSE for details.
