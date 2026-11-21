# Changelog

All notable changes to this project are documented in this file.

## 1.2.0 (Unreleased)

### Deprecated

- Marked the backports that are superseded by native APIs as deprecated, so that apps can fix the warnings before moving to 2.0. Nothing is removed. See the README for the list of deprecated APIs and their native replacements.
- Every public symbol that 2.0 removes carries a deprecation, including the `*Backport` types, `LimitBehavior`, `SearchUnavailableBackportContent`, `ShapeStyleBackport`, `RedactionReasons.invalidated` and the modifier types in `SwiftUIBackportModifiers`.
- Deprecations are scoped to the OS version that introduces the native API (iOS 17 / macOS 14 / tvOS 17 / watchOS 10, or iOS 16.4 / macOS 13.3 / tvOS 16.4 / watchOS 9.4 for the presentation APIs), so they only show up once the deployment target reaches that version.
- Deprecated `selectionDisabled(_:)`, `SelectionDisabledModifier`, `SelectionDisabledTraitKey` and `traitValues.selectionDisabled`. Use the native `selectionDisabled(_:)`.
- Deprecated `DragGesture(minimumDistance:coordinateSpace:allowedDirections:)`. It moves to the separate `SwiftUIBackportsUnsafe` product in 2.0.

### Fixed

- `DragGesture(minimumDistance:coordinateSpace:allowedDirections:)` no longer traps on OS 27, where `DragGesture` is larger than the internal structure it was reinterpreted from. When the sizes do not match, the gesture is created with `DragGesture(minimumDistance:coordinateSpace:)` and `allowedDirections` is not applied.

## 1.1.7

- Fixed reflected subview tag lookup.
