//
//  View+InvalidatableContent.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 10.09.2024.
//

import SwiftUI

extension View {

    /// Mark the receiver as their content might be invalidated.
    ///
    /// Use this modifier to annotate views that display values that are derived
    /// from the current state of your data and might be invalidated in
    /// response of, for example, user interaction.
    ///
    /// The view will change its appearance when ``RedactionReasons.invalidated``
    /// is present in the environment.
    ///
    /// In an interactive widget a view is invalidated from the moment the user
    /// interacts with a control on the widget to the moment when a new timeline
    /// update has been presented.
    ///
    /// - Parameters:
    ///   - invalidatable: Whether the receiver content might be invalidated.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @available(iOS, deprecated: 17.0)
    @_disfavoredOverload
    public func invalidatableContent(_ invalidatable: Bool = true) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return self.invalidatableContent(invalidatable)
        } else {
            return self
        }
    }

}

extension RedactionReasons {
    public static var invalidated: RedactionReasons {
        RedactionReasons(rawValue: 4)
    }
}
