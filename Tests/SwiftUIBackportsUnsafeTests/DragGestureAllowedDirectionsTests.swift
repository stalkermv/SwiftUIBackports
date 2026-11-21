//
//  DragGestureAllowedDirectionsTests.swift
//  SwiftUIBackportsUnsafeTests
//

#if !os(tvOS)
import SwiftUI
import Testing
@testable import SwiftUIBackportsUnsafe

/// Verifies that `DragGesture(allowedDirections:)` constructs a valid `DragGesture`
/// through SwiftUI's SPI initializer while preserving all other fields (`minimumDistance`,
/// `minimumDuration`, `coordinateSpace`, `inputKinds`).
@MainActor
@Suite("DragGesture(allowedDirections:)")
struct DragGestureAllowedDirectionsTests {
    /// Every reflected field except `allowedDirections`, formatted as `label=value`.
    private func otherFields(_ gesture: DragGesture) -> [String] {
        Mirror(reflecting: gesture).children
            .filter { $0.label != "allowedDirections" }
            .map { "\($0.label ?? "?")=\(String(reflecting: $0.value))" }
    }

    @Test("Stores all individual and combined _EventDirections values")
    func storesDirections() {
        let cases: [_EventDirections] = [
            .horizontal,
            .vertical,
            .left,
            .right,
            .up,
            .down,
            [.up, .left],
            [.down, .right],
            .all,
            [],
        ]
        for directions in cases {
            let gesture = DragGesture(allowedDirections: directions)
            #expect(gesture._allowedDirections == directions)
        }
    }

    @Test("A plain DragGesture defaults to .all directions")
    func plainGestureAllowsAll() {
        #expect(DragGesture()._allowedDirections == .all)
    }

    @Test("Keeps every other reflected field identical to the public initializer", arguments: [
        CGFloat(0), 10, 42.5,
    ])
    func keepsOtherFields(_ minimumDistance: CGFloat) {
        let cases: [(DragGesture, DragGesture)] = [
            (
                DragGesture(minimumDistance: minimumDistance),
                DragGesture(minimumDistance: minimumDistance, allowedDirections: .vertical)
            ),
            (
                DragGesture(minimumDistance: minimumDistance, coordinateSpace: .global),
                DragGesture(minimumDistance: minimumDistance, coordinateSpace: .global, allowedDirections: .horizontal)
            ),
            (
                DragGesture(minimumDistance: minimumDistance, coordinateSpace: .named("space")),
                DragGesture(minimumDistance: minimumDistance, coordinateSpace: .named("space"), allowedDirections: .left)
            ),
            (
                DragGesture(minimumDistance: minimumDistance, coordinateSpace: CoordinateSpace.named("legacy")),
                DragGesture(minimumDistance: minimumDistance, coordinateSpace: CoordinateSpace.named("legacy"), allowedDirections: .up)
            ),
        ]
        for (plain, directional) in cases {
            #expect(otherFields(directional) == otherFields(plain))
            #expect(directional.minimumDistance == minimumDistance)
            #expect(directional.coordinateSpace == plain.coordinateSpace)
        }
    }

    @Test("Mutating public properties preserves allowedDirections and vice versa")
    func publicPropertiesStayIndependent() {
        var gesture = DragGesture(minimumDistance: 12, coordinateSpace: .local, allowedDirections: .horizontal)
        gesture.minimumDistance = 77
        gesture.coordinateSpace = .global
        #expect(gesture.minimumDistance == 77)
        #expect(gesture.coordinateSpace == .global)
        #expect(gesture._allowedDirections == .horizontal)
    }

    @Test("Composes with onChanged, onEnded, SimultaneousGesture, ExclusiveGesture, and ScrollView")
    func composesWithGestureAndScrollHierarchy() {
        let horizontal = DragGesture(minimumDistance: 15, coordinateSpace: .named("scroll"), allowedDirections: .horizontal)
        let vertical = DragGesture(minimumDistance: 8, coordinateSpace: CoordinateSpace.local, allowedDirections: .vertical)

        let view = ScrollView(.vertical) {
            Rectangle()
                .frame(width: 200, height: 120)
                .gesture(
                    horizontal
                        .onChanged { _ in }
                        .onEnded { _ in }
                        .exclusively(before: vertical.onEnded { _ in })
                )
                .simultaneousGesture(
                    DragGesture(allowedDirections: [.left, .right])
                        .updating(GestureState<CGSize>(initialValue: .zero)) { value, state, _ in
                            state = value.translation
                        }
                )
        }
        .coordinateSpace(name: "scroll")

        _ = view
        #expect(horizontal._allowedDirections == .horizontal)
        #expect(vertical._allowedDirections == .vertical)
    }
}
#endif
