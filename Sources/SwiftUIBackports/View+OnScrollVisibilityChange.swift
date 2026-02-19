//
//  View+OnScrollVisibilityChange.swift
//  SwiftUIBackports
//
//  Created by Valeriy Malishevskyi on 30.12.2025.
//

import SwiftUI
import SwiftUIBackportModifiers

extension View {
    /// Adds an action to be called when the view crosses the threshold to be considered on/off screen.
    ///
    /// Use this modifier to be informed when the view has crossed the
    /// provided threshold to be considered on/off screen.
    ///
    ///     struct VideoPlayer: View {
    ///         @State var playing: Bool
    ///
    ///         var body: some View {
    ///             Group {
    ///                 // ...
    ///             }
    ///             .onScrollVisibilityChange(threshold: 0.2) { isVisible in
    ///                 playing = isVisible
    ///             }
    ///         }
    ///     }
    ///
    /// When the view appears on-screen, the action will be called if the threshold
    /// has already been reached.
    ///
    /// - Parameters:
    ///   - threshold: The amount required to be visible within the viewport of the parent
    ///   view before the `action` is fired. By default when the view has crossed more than 50%
    ///   on-screen, the action will be called.
    ///   - action: The action which will be called when the threshold has been reached.
    @_disfavoredOverload
    @ViewBuilder
    public func onScrollVisibilityChange(
        threshold: Double = 0.5,
        _ action: @escaping (Bool) -> Void
    ) -> some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 10.0, *) {
            self.onScrollVisibilityChange(threshold: threshold, action)
        } else {
            self.modifier(
                ScrollVisibilityChangeBackportModifier(
                    threshold: threshold,
                    action: action
                )
            )
        }
    }
}
