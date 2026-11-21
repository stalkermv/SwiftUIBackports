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
    /// `IsSelectionEnabledTraitKey` trait that the modifier writes. Keep these limits in mind:
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
            let fields = Mirror(reflecting: entry).children
            guard let key = fields.first(where: { $0.label == "key" }),
                  String(reflecting: key.value).contains("IsSelectionEnabledTraitKey"),
                  let isEnabled = fields.first(where: { $0.label == "value" })?.value as? Bool
            else { continue }
            return !isEnabled
        }
        return false
    }
}
