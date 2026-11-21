import Testing
@testable import SwiftUIBackports
import SwiftUI

/// These tests read a private SwiftUI trait by reflection. If one of them fails after an OS or
/// Xcode update, SwiftUI most likely changed the private selection trait: update
/// `TraitCollectionValues.selectionDisabled`.
@MainActor
struct SelectionDisabledTraitTests {
    private static let canary = "SwiftUI changed the private selection trait (IsSelectionEnabledTraitKey)"

    private func subviews<Content: View>(@ViewBuilder content: @escaping () -> Content) -> [SwiftUIBackports.Subview] {
        var captured: [SwiftUIBackports.Subview] = []
        let tree = ViewTree(content) { children in
            let _ = { captured = Array(children) }()
            Color.clear.frame(width: 1, height: 1)
        }
        _ = ImageRenderer(content: tree).cgImage
        return captured
    }

    private func flags<Content: View>(@ViewBuilder content: @escaping () -> Content) -> [Bool] {
        subviews(content: content).map { $0.traitValues.selectionDisabled }
    }

    @Test("The native modifier writes the private trait this reader looks for")
    func nativeTraitIsPresent() {
        let children = subviews { Text("a").selectionDisabled(true) }
        #expect(children.count == 1)
        let hasTrait = children.first?.traitValues.values.contains { entry in
            Mirror(reflecting: entry).children.contains {
                $0.label == "key" && String(reflecting: $0.value).contains("IsSelectionEnabledTraitKey")
            }
        }
        #expect(hasTrait == true, Comment(rawValue: Self.canary))
    }

    @Test("A plain child is not disabled")
    func plainChild() {
        #expect(flags { Text("a") } == [false], Comment(rawValue: Self.canary))
    }

    @Test("selectionDisabled(true) and selectionDisabled() disable selection")
    func disabled() {
        #expect(flags { Text("a").selectionDisabled(true) } == [true], Comment(rawValue: Self.canary))
        #expect(flags { Text("a").selectionDisabled() } == [true], Comment(rawValue: Self.canary))
    }

    @Test("selectionDisabled(false) keeps selection enabled")
    func enabled() {
        #expect(flags { Text("a").selectionDisabled(false) } == [false], Comment(rawValue: Self.canary))
    }

    @Test("Other modifiers before or after selectionDisabled do not hide it")
    func wrapped() {
        #expect(flags { Text("a").padding().selectionDisabled(true) } == [true], Comment(rawValue: Self.canary))
        #expect(flags { Text("a").selectionDisabled(true).padding() } == [true], Comment(rawValue: Self.canary))
        #expect(flags { Text("a").selectionDisabled(true).padding().background(.red) } == [true], Comment(rawValue: Self.canary))
    }

    @Test("It works together with tag")
    func withTag() {
        #expect(flags { Text("a").tag(1).selectionDisabled(true) } == [true], Comment(rawValue: Self.canary))
        #expect(flags { Text("a").selectionDisabled(true).tag(1) } == [true], Comment(rawValue: Self.canary))
        let tagged = subviews { Text("a").selectionDisabled(true).tag(1) }
        #expect(tagged.first?.traitValues.tag(for: Int.self) == 1)
    }

    @Test("Each child of a ForEach has its own flag")
    func mixedChildren() {
        let result = flags {
            Text("a")
            Text("b").selectionDisabled(true)
            ForEach(0..<3, id: \.self) { index in
                Text("\(index)").selectionDisabled(index == 1)
            }
        }
        #expect(result == [false, true, false, true, false], Comment(rawValue: Self.canary))
    }

    @Test("With two modifiers on one child, the innermost one wins, as in SwiftUI")
    func innermostWins() {
        #expect(flags { Text("a").selectionDisabled(true).selectionDisabled(false) } == [true], Comment(rawValue: Self.canary))
        #expect(flags { Text("a").selectionDisabled(false).selectionDisabled(true) } == [false], Comment(rawValue: Self.canary))
    }

    @Test("A modifier on a stack applies to the stack, not to the views inside it")
    func stackDoesNotReachChildren() {
        let result = flags { VStack { Text("a"); Text("b") }.selectionDisabled(true) }
        #expect(result == [true], Comment(rawValue: Self.canary))
        let inner = subviews { VStack { Text("a"); Text("b") }.selectionDisabled(true) }
        #expect(inner.count == 1)
    }

    @Test("A modifier on a Group reaches every view in the group")
    func groupReachesChildren() {
        let result = flags { Group { Text("a"); Text("b") }.selectionDisabled(true) }
        #expect(result == [true, true], Comment(rawValue: Self.canary))
    }
}
