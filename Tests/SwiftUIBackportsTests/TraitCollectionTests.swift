//
//  TraitCollectionTests.swift
//  SwiftUIBackports
//

import Testing
@testable import SwiftUIBackports
import SwiftUI

@MainActor
struct TraitCollectionTests {
    enum SampleOption: String, Hashable {
        case first
        case second
    }

    private func extractSubviews<Content: View>(@ViewBuilder content: @escaping () -> Content) -> [SwiftUIBackports.Subview] {
        var captured: [SwiftUIBackports.Subview] = []
        let tree = ViewTree(content) { children in
            let _ = { captured = Array(children) }()
            Color.clear.frame(width: 1, height: 1)
        }
        _ = ImageRenderer(content: tree).cgImage
        return captured
    }

    @Test("Extracts non-optional and optional tags from tagged view")
    func extractsTaggedValues() {
        let subviews = extractSubviews {
            Text("First")
                .tag(SampleOption.first)
        }

        #expect(subviews.count == 1)
        let traits = subviews[0].traitValues

        #expect(traits.tag(for: SampleOption.self) == .first)
        #expect(traits.tag(for: SampleOption?.self) == .some(.first))
        #expect(traits.hasTag(SampleOption.first))
        #expect(traits.hasTag(Optional<SampleOption>.some(.first)))
        #expect(!traits.hasTag(SampleOption.second))
    }

    @Test("Extracts explicit Optional.none tag without confusing untagged views")
    func extractsExplicitNilOptionalTag() {
        let subviews = extractSubviews {
            Text("None")
                .tag(Optional<SampleOption>.none)
        }

        #expect(subviews.count == 1)
        let traits = subviews[0].traitValues

        #expect(traits.tag(for: SampleOption.self) == nil)
        let optionalTag = traits.tag(for: SampleOption?.self)
        #expect(optionalTag != nil)
        #expect(optionalTag == .some(nil))
        #expect(traits.hasTag(Optional<SampleOption>.none))
    }

    @Test("Returns nil for untagged views and mismatched tag types, even when querying Optional")
    func returnsNilForUntaggedAndMismatchedViews() {
        let subviews = extractSubviews {
            Text("Untagged")
            Text("String Tag")
                .tag("other")
        }

        #expect(subviews.count == 2)

        let untaggedTraits = subviews[0].traitValues
        #expect(untaggedTraits.tag(for: SampleOption.self) == nil)
        #expect(untaggedTraits.tag(for: SampleOption?.self) == nil)
        #expect(!untaggedTraits.hasTag(SampleOption.first))
        #expect(!untaggedTraits.hasTag(Optional<SampleOption>.none))

        let mismatchedTraits = subviews[1].traitValues
        #expect(mismatchedTraits.tag(for: SampleOption.self) == nil)
        #expect(mismatchedTraits.tag(for: SampleOption?.self) == nil)
        #expect(mismatchedTraits.tag(for: String.self) == "other")
    }

    @Test("Respects includeOptional: false when querying Optional tag")
    func respectsIncludeOptionalFalse() {
        let subviews = extractSubviews {
            Text("Non-optional only")
                .tag(SampleOption.first, includeOptional: false)
        }

        #expect(subviews.count == 1)
        let traits = subviews[0].traitValues

        #expect(traits.tag(for: SampleOption.self) == .first)
        #expect(traits.tag(for: SampleOption?.self) == nil)
    }
}