//
//  DragGesture.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 27.09.2024.
//

import SwiftUI

struct _DragGesture {
    var minimumDistance: CGFloat
    var coordinateSpace: CoordinateSpace
    var allowedDirections: _EventDirections
}

extension DragGesture {
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
