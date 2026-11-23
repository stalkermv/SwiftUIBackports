# Changelog

All notable changes to this project are documented in this file.

## 2.0.0 - 2026-11-23

### Breaking

- Minimum deployments are now iOS 17, macOS 14, Mac Catalyst 17, tvOS 17, watchOS 10 and visionOS 2 (previously iOS 16 and macOS 13).
- Removed every backport whose native API is available at the new minimums: `onChange(of:initial:_:)`, `safeAreaPadding(_:)`, `contentMargins(_:_:for:)`, `containerRelativeFrame(...)`, `scrollTargetLayout()`, `scrollTargetBehavior(_:)`, `scrollPosition(id:anchor:)`, `scrollClipDisabled(_:)`, `sensoryFeedback(...)`, `invalidatableContent(_:)`, `toolbarTitleDisplayMode(_:)`, `ContentUnavailableView`, `ShapeStyle.fill`, `presentationCornerRadius(_:)`, `presentationBackgroundInteraction(_:)`, `presentationCompactAdaptation(_:)` and `Text(_:format:)`, together with their supporting `*Backport` types. See the migration table in the README.
- Removed `selectionDisabled(_:)`, `SelectionDisabledModifier` and `SelectionDisabledTraitKey`. The backport was ambiguous with the native iOS 17 / macOS 14 `selectionDisabled(_:)` when `SwiftUI` and `SwiftUIBackports` are imported in the same file. Use the native modifier.
- `DragGesture(minimumDistance:coordinateSpace:allowedDirections:)` moved out of `SwiftUIBackports` into the new `SwiftUIBackportsUnsafe` product. Add `import SwiftUIBackportsUnsafe` to keep using it.

### Added

- visionOS 2 support.
- `SwiftUIBackportsUnsafe` product for helpers that link against non-public SwiftUI symbols. It is not covered by semantic versioning.

### Changed

- `traitValues.selectionDisabled` is now a read-only accessor that reads the flag of the native `selectionDisabled(_:)` by reflection, so custom containers can honor it.

### Fixed

- `DragGesture(allowedDirections:)` no longer traps on OS 27. It now calls SwiftUI's own initializer instead of assuming the size and layout of `DragGesture`.
- Compiler warnings in `onScrollGeometryChange` (isolated `Equatable` conformance, deprecated `onChange`) on all platforms.
- `onScrollVisibilityChange` and `onScrollGeometryChange` build on visionOS and use the native modifiers there.
- Enabling the `useSwiftUIIntrospect` trait no longer breaks watchOS builds; the trait is ignored on platforms SwiftUIIntrospect does not support.
- `tabViewPageClipDisabled` no longer lists iOS 16 and macOS 13 and earlier in its SwiftUIIntrospect support list.
- With the `useSwiftUIIntrospect` trait enabled, `tabViewPageClipDisabled` returned an empty view on tvOS and visionOS because its body had no branch for those platforms. It now returns the content unchanged there.
- The `onScrollGeometryChange` fallback used an iOS-only SwiftUIIntrospect predicate on every UIKit platform, so it never matched on tvOS. It now uses `.tvOS(.v17)` on tvOS (and `.visionOS(.v2)` on visionOS) and `.iOS(.v17)` on iOS and Mac Catalyst.

## 1.1.7

- Fixed reflected subview tag lookup.
