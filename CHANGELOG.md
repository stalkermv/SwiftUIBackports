# Changelog

All notable changes to this project are documented in this file.

## 2.0.0 (Unreleased)

### Breaking

- Minimum deployments are now iOS 17, macOS 14, Mac Catalyst 17, tvOS 17, watchOS 10 and visionOS 2 (previously iOS 16 and macOS 13).
- Removed every backport whose native API is available at the new minimums: `onChange(of:initial:_:)`, `safeAreaPadding(_:)`, `contentMargins(_:_:for:)`, `containerRelativeFrame(...)`, `scrollTargetLayout()`, `scrollTargetBehavior(_:)`, `scrollPosition(id:anchor:)`, `scrollClipDisabled(_:)`, `sensoryFeedback(...)`, `invalidatableContent(_:)`, `toolbarTitleDisplayMode(_:)`, `ContentUnavailableView`, `ShapeStyle.fill`, `presentationCornerRadius(_:)`, `presentationBackgroundInteraction(_:)`, `presentationCompactAdaptation(_:)` and `Text(_:format:)`, together with their supporting `*Backport` types. See the migration table in the README.
- Removed `selectionDisabled(_:)`, `SelectionDisabledModifier`, `SelectionDisabledTraitKey` and `traitValues.selectionDisabled`. The backport was ambiguous with the native iOS 17 / macOS 14 `selectionDisabled(_:)` when `SwiftUI` and `SwiftUIBackports` were imported in the same file. Use the native modifier.
- `DragGesture(minimumDistance:coordinateSpace:allowedDirections:)` moved out of `SwiftUIBackports` into the new `SwiftUIBackportsUnsafe` product. Add `import SwiftUIBackportsUnsafe` to keep using it.

### Added

- visionOS 2 support.
- `SwiftUIBackportsUnsafe` product for helpers that link against non-public SwiftUI symbols. It is not covered by semantic versioning.

### Fixed

- `DragGesture(allowedDirections:)` no longer traps on OS 27. It now calls SwiftUI's own initializer instead of assuming the size and layout of `DragGesture`.
- Compiler warnings in `onScrollGeometryChange` (isolated `Equatable` conformance, deprecated `onChange`) on all platforms.
- `onScrollVisibilityChange` and `onScrollGeometryChange` build on visionOS and use the native modifiers there.
- Enabling the `useSwiftUIIntrospect` trait no longer breaks watchOS builds; the trait is ignored on platforms SwiftUIIntrospect does not support.
- `tabViewPageClipDisabled` no longer lists iOS 16 and macOS 13 and earlier in its SwiftUIIntrospect support list.

## 1.2.0 (Unreleased)

### Deprecated

- Marked the backports that are superseded by iOS 17 APIs as deprecated, so that apps can fix the warnings before moving to 2.0. Nothing is removed. See the README for the list of deprecated APIs and their native replacements.
- Deprecated `DragGesture(minimumDistance:coordinateSpace:allowedDirections:)`. It moves to the separate `SwiftUIBackportsUnsafe` product in 2.0.

### Fixed

- `DragGesture(minimumDistance:coordinateSpace:allowedDirections:)` no longer traps on OS 27, where `DragGesture` is larger than the internal structure it was reinterpreted from. When the sizes do not match, the gesture is created with `DragGesture(minimumDistance:coordinateSpace:)` and `allowedDirections` is not applied.

## 1.1.7

- Fixed reflected subview tag lookup.
