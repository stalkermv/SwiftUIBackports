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

extension _DragGesture {
    /// Whether this structure can be reinterpreted as a `DragGesture` of the given size and alignment.
    ///
    /// `DragGesture` is not a stable layout: SwiftUI on OS 27 stores more than earlier releases,
    /// and reinterpreting a smaller structure as a larger one traps.
    static func canBridge(nativeSize: Int, nativeAlignment: Int) -> Bool {
        MemoryLayout<_DragGesture>.size == nativeSize
            && MemoryLayout<_DragGesture>.alignment == nativeAlignment
    }
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
    /// If the layout of `DragGesture` on the running OS no longer matches the internal structure
    /// (this is the case on OS 27), the gesture is created with `init(minimumDistance:coordinateSpace:)`
    /// instead. Then `allowedDirections` is **not applied** and the gesture recognizes drags in every direction.
    ///
    /// - Warning: This implementation uses `unsafeBitCast`, which can lead to undefined behavior and is not safe for production use.
    ///   In SwiftUIBackports 2.0 this initializer moves to the `SwiftUIBackportsUnsafe` product, which calls
    ///   SwiftUI's own initializer and applies `allowedDirections` on every OS.
    @available(*, deprecated, message: "Moves to the SwiftUIBackportsUnsafe product in SwiftUIBackports 2.0.")
    public init(
        minimumDistance: CGFloat = 10,
        coordinateSpace: CoordinateSpace = .local,
        allowedDirections: _EventDirections
    ) {
        guard _DragGesture.canBridge(
            nativeSize: MemoryLayout<DragGesture>.size,
            nativeAlignment: MemoryLayout<DragGesture>.alignment
        ) else {
            self.init(minimumDistance: minimumDistance, coordinateSpace: coordinateSpace)
            return
        }
        let gesture = _DragGesture(
            minimumDistance: minimumDistance,
            coordinateSpace: coordinateSpace,
            allowedDirections: allowedDirections
        )
        self = unsafeBitCast(gesture, to: DragGesture.self)
    }
}
