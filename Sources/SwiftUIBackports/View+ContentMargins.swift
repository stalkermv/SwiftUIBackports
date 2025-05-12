//
//  View+ContentMargins.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 31.08.2024.
//

import SwiftUI

extension View {

    /// Configures the content margin for a provided placement.
    ///
    /// Use this modifier to customize the content margins of different
    /// kinds of views. For example, you can use this modifier to customize
    /// the margins of scrollable views like ``ScrollView``. In the
    /// following example, the scroll view will automatically inset
    /// its content by the safe area plus an additional 20 points
    /// on the leading and trailing edge.
    ///
    ///     ScrollView(.horizontal) {
    ///         // ...
    ///     }
    ///     .contentMargins(.horizontal, 20.0)
    ///
    /// You can provide a ``ContentMarginPlacement`` to target specific
    /// parts of a view to customize. For example, provide a
    /// ``ContentMargingPlacement/scrollContent`` placement to
    /// inset the content of a ``TextEditor`` without affecting the
    /// insets of its scroll indicators.
    ///
    ///     TextEditor(text: $text)
    ///         .contentMargins(.horizontal, 20.0, for: .scrollContent)
    ///
    /// Similarly, you can customize the insets of scroll indicators
    /// separately from scroll content. Consider doing this when applying
    /// a custom clip shape that may clip the indicators.
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .clipShape(.rect(cornerRadius: 20.0))
    ///     .contentMargins(10.0, for: .scrollIndicators)
    ///
    /// When applying multiple contentMargins modifiers, modifiers with
    /// the same placement will override modifiers higher up in the view
    /// hierarchy.
    ///
    /// - Parameters:
    ///   - edges: The edges to add the margins to.
    ///   - insets: The amount of margins to add.
    ///   - placement: Where the margins should be added.
//    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//    @available(iOS, deprecated: 17, message: "Use native SwiftUI API instead")
//    nonisolated public func contentMargins(_ edges: Edge.Set = .all, _ insets: EdgeInsets, for placement: ContentMarginPlacementBackport = .automatic) -> some View {
//        if #available(iOS 17.0, *) {
//            return self.contentMargins(edges, insets, for: placement.backport)
//        } else {
//            return self.modifier(
//                ContentMarginsBackportModifier(edges: edges, length: length, placement: placement)
//            )
//        }
//    }


    /// Configures the content margin for a provided placement.
    ///
    /// Use this modifier to customize the content margins of different
    /// kinds of views. For example, you can use this modifier to customize
    /// the margins of scrollable views like ``ScrollView``. In the
    /// following example, the scroll view will automatically inset
    /// its content by the safe area plus an additional 20 points
    /// on the leading and trailing edge.
    ///
    ///     ScrollView(.horizontal) {
    ///         // ...
    ///     }
    ///     .contentMargins(.horizontal, 20.0)
    ///
    /// You can provide a ``ContentMarginPlacement`` to target specific
    /// parts of a view to customize. For example, provide a
    /// ``ContentMargingPlacement/scrollContent`` placement to
    /// inset the content of a ``TextEditor`` without affecting the
    /// insets of its scroll indicators.
    ///
    ///     TextEditor(text: $text)
    ///         .contentMargins(.horizontal, 20.0, for: .scrollContent)
    ///
    /// Similarly, you can customize the insets of scroll indicators
    /// separately from scroll content. Consider doing this when applying
    /// a custom clip shape that may clip the indicators.
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .clipShape(.rect(cornerRadius: 20.0))
    ///     .contentMargins(10.0, for: .scrollIndicators)
    ///
    /// When applying multiple contentMargins modifiers, modifiers with
    /// the same placement will override modifiers higher up in the view
    /// hierarchy.
    ///
    /// - Parameters:
    ///   - edges: The edges to add the margins to.
    ///   - length: The amount of margins to add.
    ///   - placement: Where the margins should be added.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @available(iOS, deprecated: 17, message: "Use native SwiftUI API instead")
    public func contentMargins(_ edges: Edge.Set = .all, _ length: CGFloat? = nil, for placement: ContentMarginPlacementBackport = .automatic) -> some View {
        if #available (iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return contentMargins(edges, length, for: placement.backport)
        } else {
            return self.modifier(
                ContentMarginsBackportModifier(edges: edges, length: length, placement: placement)
            )
        }
    }


    /// Configures the content margin for a provided placement.
    ///
    /// Use this modifier to customize the content margins of different
    /// kinds of views. For example, you can use this modifier to customize
    /// the margins of scrollable views like ``ScrollView``. In the
    /// following example, the scroll view will automatically inset
    /// its content by the safe area plus an additional 20 points
    /// on the leading and trailing edge.
    ///
    ///     ScrollView(.horizontal) {
    ///         // ...
    ///     }
    ///     .contentMargins(.horizontal, 20.0)
    ///
    /// You can provide a ``ContentMarginPlacement`` to target specific
    /// parts of a view to customize. For example, provide a
    /// ``ContentMargingPlacement/scrollContent`` placement to
    /// inset the content of a ``TextEditor`` without affecting the
    /// insets of its scroll indicators.
    ///
    ///     TextEditor(text: $text)
    ///         .contentMargins(.horizontal, 20.0, for: .scrollContent)
    ///
    /// Similarly, you can customize the insets of scroll indicators
    /// separately from scroll content. Consider doing this when applying
    /// a custom clip shape that may clip the indicators.
    ///
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .clipShape(.rect(cornerRadius: 20.0))
    ///     .contentMargins(10.0, for: .scrollIndicators)
    ///
    /// When applying multiple contentMargins modifiers, modifiers with
    /// the same placement will override modifiers higher up in the view
    /// hierarchy.
    ///
    /// - Parameters:
    ///   - length: The amount of margins to add on all edges.
    ///   - placement: Where the margins should be added.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @available(iOS, deprecated: 17, message: "Use native SwiftUI API instead")
    public func contentMargins(_ length: CGFloat, for placement: ContentMarginPlacementBackport = .automatic) -> some View {
        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
            return contentMargins(.all, length, for: placement.backport)
        } else {
            return self.modifier(
                ContentMarginsBackportModifier(edges: .all, length: length, placement: .scrollContent)
            )
        }
    }

}

public struct ContentMarginPlacementBackport {
    public enum ContentMarginPlacement {
        case automatic
        case scrollContent
        case scrollIndicators
    }
    
    let value: ContentMarginPlacement

    /// The automatic placement.
    ///
    /// Views that support margin customization can automatically use
    /// margins with this placement. For example, a ``ScrollView`` will
    /// use this placement to automatically inset both its content and
    /// scroll indicators by the specified amount.
    public static var automatic: Self {
        .init(value: .automatic)
    }

    /// The scroll content placement.
    ///
    /// Scrollable views like ``ScrollView`` will use this placement to
    /// inset their content, but not their scroll indicators.
    public static var scrollContent: Self {
        .init(value: .scrollContent)
    }

    /// The scroll indicators placement.
    ///
    /// Scrollable views like ``ScrollView`` will use this placement to
    /// inset their scroll indicators, but not their content.
    public static var scrollIndicators: Self {
        .init(value: .scrollIndicators)
    }
    
    public init(value: ContentMarginPlacement) {
        self.value = value
    }
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    var backport: SwiftUI.ContentMarginPlacement {
        switch value {
        case .automatic: return .automatic
        case .scrollContent: return .scrollContent
        case .scrollIndicators: return .scrollIndicators
        }
    }
}

struct ContentMarginsBackportModifier: ViewModifier {
    let edges: Edge.Set
    let length: CGFloat?
    let placement: ContentMarginPlacementBackport

    func body(content: Content) -> some View {
        #if os(iOS)
        content.introspect(.scrollView, on: .iOS(.v16)) { scrollView in
            if let length = length {
                scrollView.contentInset = UIEdgeInsets(
                    top: edges.contains(.top) ? -length : 0,
                    left: edges.contains(.leading) ? length : 0,
                    bottom: edges.contains(.bottom) ? -length : 0,
                    right: edges.contains(.trailing) ? length : 0
                )
            }
        }
        #elseif os(macOS)
        content.introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15)) { scrollView in
            if let length = length {
                scrollView.contentInsets = NSEdgeInsets(
                    top: edges.contains(.top) ? -length : 0,
                    left: edges.contains(.leading) ? length : 0,
                    bottom: edges.contains(.bottom) ? -length : 0,
                    right: edges.contains(.trailing) ? length : 0
                )
            }
        }
        #endif
    }
}
