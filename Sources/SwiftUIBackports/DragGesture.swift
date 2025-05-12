//
//  DragGesture.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 27.09.2024.
//

import SwiftUI

/// An internal representation of a customized drag gesture.
///
/// `_DragGesture` allows you to encapsulate configuration options such as the minimum drag
/// distance, coordinate space, and directional constraints. It is intended to be used
/// internally with unsafe bridging into SwiftUI's `DragGesture`.
struct _DragGesture {
    var minimumDistance: CGFloat
    var coordinateSpace: CoordinateSpace
    var allowedDirections: _EventDirections
}

extension DragGesture {
    /// Creates a drag gesture with directional constraints using internal configuration.
    ///
    /// This initializer is a workaround to enable setting additional gesture constraints,
    /// such as allowed directions, which are not natively supported by `DragGesture`.
    /// It uses an internal `_DragGesture` structure and performs an unsafe cast to `DragGesture`.
    ///
    /// ```swift
    /// let gesture = DragGesture(allowedDirections: [.up, .down])
    /// ```
    ///
    /// - Parameters:
    ///   - minimumDistance: The minimum movement required before the gesture is recognized. Default is `10`.
    ///   - coordinateSpace: The coordinate space in which the gesture should operate. Default is `.local`.
    ///   - allowedDirections: A custom set of allowed drag directions (from `_EventDirections`).
    ///
    /// - Warning: This implementation uses `unsafeBitCast`, which can lead to undefined behavior and is not safe for production use.
    public init(
        minimumDistance: CGFloat = 10,
        coordinateSpace: CoordinateSpace = .local,
        allowedDirections: _EventDirections
    ) {
        let gesture = _DragGesture(
            minimumDistance: minimumDistance,
            coordinateSpace: coordinateSpace,
            allowedDirections: allowedDirections
        )
        self = unsafeBitCast(gesture, to: DragGesture.self)
    }
}
