//
//  View+OnScrollGeometryChange.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 01.10.2024.
//

import SwiftUI
import SwiftUIBackportModifiers

extension View {
    /// Adds an action to be performed when a value, created from a
    /// scroll geometry, changes.
    ///
    /// The geometry of a scroll view changes frequently while scrolling.
    /// You should avoid updating large parts of your app whenever
    /// the scroll geometry changes. To aid in this, you provide two
    /// closures to this modifier:
    ///   * transform: This converts a value of ``ScrollGeometry`` to a
    ///     your own data type.
    ///   * action: This provides the data type you created in `of`
    ///     and is called whenever the data type changes.
    ///
    /// For example, you can use this modifier to know when the user scrolls
    /// a scroll view beyond the top of its content. In the following example,
    /// the data type you convert to is a ``Bool`` and the action is called
    /// whenever the ``Bool`` changes.
    ///
    ///     @Binding var isBeyondZero: Bool
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .onScrollGeometryChange(for: Bool.self) { geometry in
    ///         geometry.contentOffset.y < geometry.contentInsets.top
    ///     } action: { wasBeyondZero, isBeyondZero in
    ///         self.isBeyondZero = isBeyondZero
    ///     }
    ///
    /// If multiple scroll views are found within the view hierarchy,
    /// only the first one will invoke the closure you provide and a runtime
    /// issue will be logged. For example, in the following view, only the
    /// vertical scroll view will have its geometry changes invoke the provided
    /// closure.
    ///
    ///     VStack {
    ///         ScrollView(.vertical) { ... }
    ///         ScrollView(.horizontal) { ... }
    ///     }
    ///     .onScrollGeometryChange(for: Bool.self) { geometry in
    ///          ...
    ///     } action: { oldValue, newValue in
    ///         ...
    ///     }
    ///
    /// For responding to non-scroll geometry changes, see the
    /// ``View/onGeometryChange(for:of:action:)`` modifier.
    ///
    /// - Parameters:
    ///   - type: The type of value transformed from a ``ScrollGeometry``.
    ///   - transform: A closure that transforms a ``ScrollGeometry``
    ///     to your type.
    ///   - action: A closure to run when the transformed data changes.
    ///   - oldValue: The old value that failed the comparison check.
    ///   - newValue: The new value that failed the comparison check.
    @available(iOS, introduced: 14.0, deprecated: 18.0)
    @_disfavoredOverload
    public func onScrollGeometryChange<T>(
        for type: T.Type,
        of transform: @escaping (SwiftUIBackportModifiers.ScrollGeometry) -> T,
        action: @escaping (_ oldValue: T, _ newValue: T) -> Void
    ) -> some View where T : Equatable {
        modifier(OnScrollGeometryChangeBackportModifier(type: type, transform: transform, action: action))
    }
}
