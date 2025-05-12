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
}
