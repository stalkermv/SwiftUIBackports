# Changelog

All notable changes to this project are documented in this file.

## 1.2.0 (Unreleased)

### Deprecated

- Marked the backports that are superseded by iOS 17 APIs as deprecated, so that apps can fix the warnings before moving to 2.0. Nothing is removed. See the README for the list of deprecated APIs and their native replacements.
- Deprecated `DragGesture(minimumDistance:coordinateSpace:allowedDirections:)`. It moves to the separate `SwiftUIBackportsUnsafe` product in 2.0.

### Fixed

- `DragGesture(minimumDistance:coordinateSpace:allowedDirections:)` no longer traps on OS 27, where `DragGesture` is larger than the internal structure it was reinterpreted from. When the sizes do not match, the gesture is created with `DragGesture(minimumDistance:coordinateSpace:)` and `allowedDirections` is not applied.

## 1.1.7

- Fixed reflected subview tag lookup.
