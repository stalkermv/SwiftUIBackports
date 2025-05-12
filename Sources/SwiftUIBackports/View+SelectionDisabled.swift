//
//  View+SelectionDisabled.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 14.08.2024.
//


import SwiftUI
import SwiftUIBackportModifiers

extension View {

    /// Adds a condition that controls whether users can select this view.
    ///
    /// Use this modifier to control the selectability of views in
    /// selectable containers like ``List`` or ``Table``. In the example,
    /// below, the user can't select the first item in the list.
    ///
    ///     @Binding var selection: Item.ID?
    ///     @Binding var items: [Item]
    ///
    ///     var body: some View {
    ///         List(selection: $selection) {
    ///             ForEach(items) { item in
    ///                 ItemView(item: item)
    ///                     .selectionDisabled(item.id == items.first?.id)
    ///             }
    ///         }
    ///     }
    ///
    /// You can also use this modifier to specify the selectability of views
    /// within a `Picker`. The following example represents a flavor picker
    /// that disables selection on flavors that are unavailable.
    ///
    ///     Picker("Flavor", selection: $selectedFlavor) {
    ///         ForEach(Flavor.allCases) { flavor in
    ///             Text(flavor.rawValue.capitalized)
    ///                 .selectionDisabled(isSoldOut(flavor))
    ///         }
    ///     }
    ///
    /// - Parameter isDisabled: A Boolean value that determines whether users can
    ///   select this view.
    public func selectionDisabled(_ isDisabled: Bool = true) -> ModifiedContent<Self, SelectionDisabledModifier> {
        modifier(SelectionDisabledModifier(isDisabled: isDisabled))
    }
}

extension TraitCollectionValues {
    public var selectionDisabled: Bool {
        return self[SelectionDisabledTraitKey.self]
    }
}
