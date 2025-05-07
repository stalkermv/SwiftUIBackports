//
//  View+ScrollTransition.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 15.09.2024.
//

import SwiftUI

//extension View {
//
//    /// Applies the given transition, animating between the phases
//    /// of the transition as this view appears and disappears within the
//    /// visible region of the containing scroll view, or other container
//    /// specified using the `coordinateSpace` parameter.
//    ///
//    /// - Parameters:
//    ///   - configuration: The configuration controlling how the
//    ///     transition will be applied. The configuration will be applied both
//    ///     while the view is coming into view and while it is disappearing (the
//    ///     transition is symmetrical).
//    ///   - axis: The axis of the containing scroll view over which the
//    ///     transition will be applied. The default value of `nil` uses the
//    ///     axis of the innermost containing scroll view, or `.vertical` if
//    ///     the innermost scroll view is scrollable along both axes.
//    ///   - coordinateSpace: The coordinate space of the container that
//    ///     visibility is evaluated within. Defaults to `.scrollView`.
//    ///   - transition: A closure that applies visual effects as a function of
//    ///     the provided phase.
//    public func scrollTransition(
//        _ configuration: ScrollTransitionConfiguration = .interactive,
//        axis: Axis? = nil,
//        transition: @escaping @Sendable (EmptyVisualEffect, ScrollTransitionPhase) -> some VisualEffect
//    ) -> some View
//
//
//    /// Applies the given transition, animating between the phases
//    /// of the transition as this view appears and disappears within the
//    /// visible region of the containing scroll view, or other container
//    /// specified using the `coordinateSpace` parameter.
//    ///
//    /// - Parameters:
//    ///   - transition: the transition to apply.
//    ///   - topLeading: The configuration that drives the transition when
//    ///     the view is about to appear at the top edge of a vertical
//    ///     scroll view, or the leading edge of a horizont scroll view.
//    ///   - bottomTrailing: The configuration that drives the transition when
//    ///     the view is about to appear at the bottom edge of a vertical
//    ///     scroll view, or the trailing edge of a horizont scroll view.
//    ///   - axis: The axis of the containing scroll view over which the
//    ///     transition will be applied. The default value of `nil` uses the
//    ///     axis of the innermost containing scroll view, or `.vertical` if
//    ///     the innermost scroll view is scrollable along both axes.
//    ///   - transition: A closure that applies visual effects as a function of
//    ///     the provided phase.
//    nonisolated public func scrollTransition(
//        topLeading: ScrollTransitionConfiguration,
//        bottomTrailing: ScrollTransitionConfiguration,
//        axis: Axis? = nil,
//        transition: @escaping @Sendable (EmptyVisualEffect, ScrollTransitionPhase) -> some VisualEffect
//    ) -> some View
//
//}
