//
//  View+TabViewPageClipDisabled.swift
//  SwiftUIBackports
//
//  Created by Valeriy Malishevskyi on 06.08.2024.
//

import SwiftUI
import SwiftUIBackportModifiers

extension View {
    /// Disables the scroll clipping behavior for this view.
    /// - Parameter disabled: A Boolean value that indicates whether scroll clipping is disabled.
    /// - Returns: A view that disables the scroll clipping behavior.
    ///
    /// - Note: Applies to page-style `TabView`s on iOS and to `TabView`s on macOS, and only has an effect when
    ///   the package is built with the `useSwiftUIIntrospect` trait. Without the trait, or on other platforms,
    ///   this method has no effect.
    public func tabViewPageClipDisabled(_ disabled: Bool = true) -> some View {
        modifier(TabViewPageClipDisabledModifier(disabled: disabled))
    }
}
