import SwiftUI

extension TraitCollectionValues {
    /// Whether the native `selectionDisabled(_:)` modifier disabled selection for this subview.
    ///
    /// Use it in a custom container that is built on `ForEach(subviews:)` and wants to honor the
    /// same modifier as `Picker` and `List`:
    ///
    /// ```swift
    /// ForEach(subviews: content) { subview in
    ///     Button { ... } label: { subview }
    ///         .disabled(subview.traitValues.selectionDisabled)
    /// }
    /// ```
    ///
    /// SwiftUI does not expose this flag, so it is read by reflection from the private
    /// `IsSelectionEnabledTraitKey` trait that the modifier writes. The layout of that trait
    /// differs between OS versions; the tests check macOS 15 and macOS 27 and the iOS 26 and 27
    /// simulators. Keep these limits in mind:
    ///
    /// - If a future OS renames or reshapes that trait, this returns `false` instead of failing.
    ///   The tests of this package check the trait on every supported OS.
    /// - It only sees a modifier applied directly to the subview, possibly with other
    ///   modifiers around it. A modifier on a container does not reach its children.
    /// - If a subview has the modifier more than once, the value that SwiftUI keeps wins,
    ///   which is the innermost one.
    ///
    /// - Returns: `true` if selection is disabled. If the modifier is not applied, `false`.
    public var selectionDisabled: Bool {
        for entry in values {
            if let isEnabled = Self.selectionEnabled(in: entry) {
                return !isEnabled
            }
        }
        return false
    }

    /// The "selection enabled" flag of one trait entry, or `nil` if the entry is not the
    /// selection trait.
    ///
    /// SwiftUI stores the key of a trait in different places: as a `key` field of the entry
    /// (OS 27) or as a generic argument of the entry type, `AnyTrait<IsSelectionEnabledTraitKey>`
    /// (older OS versions). Both are matched by name, and the value is the `value` field.
    static func selectionEnabled(in entry: Any) -> Bool? {
        let keyName = "IsSelectionEnabledTraitKey"
        let fields = Array(Mirror(reflecting: entry).children)
        let keyField = fields.first { $0.label == "key" }.map { String(reflecting: $0.value) } ?? ""
        guard String(reflecting: type(of: entry)).contains(keyName) || keyField.contains(keyName) else {
            return nil
        }
        return (fields.first { $0.label == "value" } ?? fields.first { $0.value is Bool })?.value as? Bool
    }
}
