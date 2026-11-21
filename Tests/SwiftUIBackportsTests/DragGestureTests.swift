//
//  DragGestureTests.swift
//  SwiftUIBackports
//
//  Created by Valeriy Malishevskyi on 12.05.2025.
//

import Testing
@testable import SwiftUIBackports
import SwiftUI

@MainActor struct DragGestureTests {
    @Test func customDragGestureInit() async throws {
        let allowedDirections = _EventDirections.up
        
        let gesture = DragGesture(allowedDirections: allowedDirections)
        
        #expect(type(of: gesture) == DragGesture.self)
    }

    @Test("Keeps the minimum distance and coordinate space on every OS", arguments: [CGFloat(0), 10, 42.5])
    func keepsConfiguration(_ minimumDistance: CGFloat) {
        let gesture = DragGesture(
            minimumDistance: minimumDistance,
            coordinateSpace: .global,
            allowedDirections: .horizontal
        )

        #expect(gesture.minimumDistance == minimumDistance)
        #expect(gesture.coordinateSpace == .global)
    }

    @Test("Bridges only when size and alignment match the native gesture")
    func bridgeCondition() {
        let size = MemoryLayout<_DragGesture>.size
        let alignment = MemoryLayout<_DragGesture>.alignment

        #expect(_DragGesture.canBridge(nativeSize: size, nativeAlignment: alignment))
        #expect(!_DragGesture.canBridge(nativeSize: size + 9, nativeAlignment: alignment))
        #expect(!_DragGesture.canBridge(nativeSize: size, nativeAlignment: alignment * 2))
    }

    @Test("Falls back to the public initializer when the layout differs")
    func fallsBackWhenLayoutDiffers() {
        let bridges = _DragGesture.canBridge(
            nativeSize: MemoryLayout<DragGesture>.size,
            nativeAlignment: MemoryLayout<DragGesture>.alignment
        )

        // Constructing never traps: with a matching layout the gesture is bridged,
        // otherwise it is created with the public initializer.
        let gesture = DragGesture(minimumDistance: 5, allowedDirections: .vertical)

        #expect(gesture.minimumDistance == 5)
        #expect(bridges == (MemoryLayout<_DragGesture>.size == MemoryLayout<DragGesture>.size))
    }
}
