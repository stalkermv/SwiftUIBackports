//
//  DragGesture+AllowedDirections.swift
//  SwiftUIBackportsUnsafe
//

import SwiftUI

// DragGesture is not available on tvOS.
#if !os(tvOS)

/// Links directly against `SwiftUI.DragGesture.init<A where A: CoordinateSpaceProtocol>(minimumDistance:coordinateSpace:allowedDirections:)`
/// exported in `SwiftUI.tbd` across iOS, macOS, Mac Catalyst, watchOS, and visionOS (OS 17+ / 26+ / 27+).
///
/// Using SwiftUI's own exported initializer avoids any assumptions about `DragGesture`'s
/// size or stored-property layout across OS releases.
@_silgen_name("$s7SwiftUI11DragGestureV15minimumDistance15coordinateSpace17allowedDirectionsAC12CoreGraphics7CGFloatV_xAA06_EventJ0VtcAA010CoordinateH8ProtocolRzlufC")
private func _swiftui_DragGesture_init<Space: CoordinateSpaceProtocol>(
    minimumDistance: CGFloat,
    coordinateSpace: Space,
    allowedDirections: _EventDirections
) -> DragGesture

private struct _BridgedCoordinateSpace: CoordinateSpaceProtocol {
    let coordinateSpace: CoordinateSpace
}

extension DragGesture {
    /// Creates a drag gesture that only recognizes drags starting in `allowedDirections`.
    ///
    /// Calls SwiftUI's SPI initializer
    /// `DragGesture.init(minimumDistance:coordinateSpace:allowedDirections:)` exported by the
    /// `SwiftUI` binary, so the gesture is constructed by SwiftUI itself with its native
    /// `minimumDuration`, `inputKinds`, and `allowedDirections` storage regardless of how
    /// `DragGesture`'s memory layout evolves across OS releases.
    ///
    /// When the drag moves past `minimumDistance` outside `allowedDirections`, recognition
    /// fails rather than swallowing the interaction, allowing an enclosing `ScrollView` or
    /// competing gesture to claim the touch/drag.
    ///
    /// ```swift
    /// let swipe = DragGesture(allowedDirections: .horizontal)
    /// ```
    ///
    /// - Parameters:
    ///   - minimumDistance: The minimum dragging distance before the gesture succeeds. Default is `10`.
    ///   - coordinateSpace: The coordinate space of the gesture's location values. Default is `.local`.
    ///   - allowedDirections: The directions in which the drag is allowed to start.
    ///
    /// - Note: Like `DragGesture` itself, which SwiftUI declares `@MainActor`, this initializer is
    ///   main-actor isolated through the type, so it has the same isolation as the native one.
    ///
    /// - Warning: Experimental — links against a non-public SwiftUI symbol (`@_silgen_name`).
    ///   Not covered by semantic versioning.
    public init(
        minimumDistance: CGFloat = 10,
        coordinateSpace: some CoordinateSpaceProtocol = .local,
        allowedDirections: _EventDirections
    ) {
        self = _swiftui_DragGesture_init(
            minimumDistance: minimumDistance,
            coordinateSpace: coordinateSpace,
            allowedDirections: allowedDirections
        )
    }

    /// Creates a drag gesture that only recognizes drags starting in `allowedDirections`,
    /// using a legacy `CoordinateSpace` value.
    ///
    /// See ``init(minimumDistance:coordinateSpace:allowedDirections:)``.
    @_disfavoredOverload
    public init(
        minimumDistance: CGFloat = 10,
        coordinateSpace: CoordinateSpace = .local,
        allowedDirections: _EventDirections
    ) {
        self = _swiftui_DragGesture_init(
            minimumDistance: minimumDistance,
            coordinateSpace: _BridgedCoordinateSpace(coordinateSpace: coordinateSpace),
            allowedDirections: allowedDirections
        )
    }

    /// The `allowedDirections` value stored in this gesture, as reported by runtime reflection.
    public var _allowedDirections: _EventDirections? {
        Mirror(reflecting: self).descendant("allowedDirections") as? _EventDirections
    }
}

extension DragGesture {
    /// Interactive preview demonstrating directional `DragGesture` inside a `ScrollView`
    /// and against competing orthogonal gestures.
    @MainActor
    fileprivate struct AllowedDirectionsDemoView: View {
        @State private var horizontalTranslation: CGFloat = 0
        @State private var horizontalEndCount: Int = 0
        @State private var verticalCardOffset: CGFloat = 0
        @State private var lastEvent: String = "Drag the card horizontally or scroll vertically."

        var body: some View {
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    Text(lastEvent)
                        .font(.footnote.monospaced())
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    swipeableCard
                    orthogonalArena
                    ForEach(1...8, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.quaternary)
                            .frame(height: 56)
                            .overlay(Text("ScrollView row \(index)").font(.subheadline))
                    }
                }
                .padding()
            }
            .coordinateSpace(name: "demoScroll")
        }

        private var swipeableCard: some View {
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue.gradient)
                .frame(height: 110)
                .offset(x: horizontalTranslation)
                .overlay {
                    VStack(spacing: 4) {
                        Text("Horizontal-only DragGesture inside vertical ScrollView")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text("dx: \(Int(horizontalTranslation)) pt • ended: \(horizontalEndCount)")
                            .font(.caption.monospaced())
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(.horizontal)
                }
                .gesture(
                    DragGesture(minimumDistance: 10, coordinateSpace: .named("demoScroll"), allowedDirections: .horizontal)
                        .onChanged { value in
                            horizontalTranslation = value.translation.width
                            lastEvent = "Horizontal changed: dx=\(Int(value.translation.width)), dy=\(Int(value.translation.height))"
                        }
                        .onEnded { value in
                            horizontalEndCount += 1
                            lastEvent = "Horizontal ended at dx=\(Int(value.translation.width))"
                            withAnimation(.spring) {
                                horizontalTranslation = 0
                            }
                        }
                )
        }

        private var orthogonalArena: some View {
            RoundedRectangle(cornerRadius: 16)
                .fill(.teal.opacity(0.2))
                .frame(height: 120)
                .offset(y: verticalCardOffset)
                .overlay {
                    Text("Vertical-only (.up / .down) • dy: \(Int(verticalCardOffset)) pt")
                        .font(.subheadline.monospaced())
                }
                .gesture(
                    DragGesture(minimumDistance: 12, allowedDirections: .vertical)
                        .onChanged { value in
                            verticalCardOffset = value.translation.height
                            lastEvent = "Vertical changed: dy=\(Int(value.translation.height))"
                        }
                        .onEnded { _ in
                            withAnimation(.spring) {
                                verticalCardOffset = 0
                            }
                        }
                )
        }
    }
}

#Preview("Directional DragGesture") {
    DragGesture.AllowedDirectionsDemoView()
}

#endif
