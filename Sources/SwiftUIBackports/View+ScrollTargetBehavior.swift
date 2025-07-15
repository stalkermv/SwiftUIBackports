//
//  View+ScrollTargetBehavior.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 31.08.2024.
//

import SwiftUI

extension View {

    /// Sets the scroll behavior of views scrollable in the provided axes.
    ///
    /// A scrollable view calculates where scroll gestures should end using its
    /// deceleration rate and the state of its scroll gesture by default. A
    /// scroll behavior allows for customizing this logic. You can provide
    /// your own ``ScrollTargetBehavior`` or use one of the built in behaviors
    /// provided by SwiftUI.
    ///
    /// ### Paging Behavior
    ///
    /// SwiftUI offers a ``PagingScrollTargetBehavior`` behavior which uses the
    /// geometry of the scroll view to decide where to allow scrolls to end.
    ///
    /// In the following example, every view in the lazy stack is flexible
    /// in both directions and the scroll view will settle to container aligned
    /// boundaries.
    ///
    ///     ScrollView {
    ///         LazyVStack(spacing: 0.0) {
    ///             ForEach(items) { item in
    ///                 FullScreenItem(item)
    ///             }
    ///         }
    ///     }
    ///     .scrollTargetBehavior(.paging)
    ///
    /// ### View Aligned Behavior
    ///
    /// SwiftUI offers a ``ViewAlignedScrollTargetBehavior`` scroll behavior
    /// that will always settle on the geometry of individual views.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///         .scrollTargetLayout()
    ///     }
    ///     .scrollTargetBehavior(.viewAligned)
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// You configure which views should be used for settling using the
    /// ``View/scrollTargetLayout(isEnabled:)`` modifier. Apply this modifier to
    /// a layout container like ``LazyVStack`` or ``HStack`` and each individual
    /// view in that layout will be considered for alignment.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @_disfavoredOverload
    nonisolated public func scrollTargetBehavior(_ behavior: ScrollTargetBehaviorBackport) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            let view = self.scrollTargetBehavior(behavior.backportValue)
            return AnyView(view)
        } else {
            return self
        }
    }
}

public enum ScrollTargetBehaviorBackport {
    case paging
    case viewAligned(limitBehavior: LimitBehavior = .automatic)
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    var backportValue: any ScrollTargetBehavior {
        switch self {
        case .paging:
            return .paging
        case .viewAligned(limitBehavior: let behavior):
            return .viewAligned(limitBehavior: behavior.backportValue)
        }
    }
}

public struct LimitBehavior {
    
    enum _Behavior {
        case automatic
        case always
        case alwaysByFew
        case alwaysByOne
        case never
    }
    
    let behavior: _Behavior

    /// The automatic limit behavior.
    ///
    /// By default, the behavior will be limited in compact horizontal
    /// size classes and will not be limited otherwise.
    public static var automatic: Self {
        LimitBehavior(behavior: .automatic)
    }

    /// The always limit behavior.
    ///
    /// Always limit the amount of views that can be scrolled.
    public static var always: Self {
        LimitBehavior(behavior: .always)
    }

    /// The always-by-few limit behavior.
    ///
    /// Limit the number of views that can be scrolled by a single
    /// interaction to a small number of views, rather than
    /// a single view at a time. The number of views is
    /// determined automatically.
    public static var alwaysByFew: Self {
        LimitBehavior(behavior: .alwaysByFew)
    }

    /// The always-by-one limit behavior.
    ///
    /// Limit the number of views that can be scrolled by
    /// a single interaction to a single view.
    public static var alwaysByOne: Self {
        LimitBehavior(behavior: .alwaysByOne)
    }

    /// The never limit behavior.
    ///
    /// Never limit the amount of views that can be scrolled.
    public static var never: Self {
        LimitBehavior(behavior: .never)
    }
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    var backportValue: ViewAlignedScrollTargetBehavior.LimitBehavior {
        switch behavior {
        case .automatic:
            return .automatic
        case .always:
            return .always
        case .alwaysByFew:
            if #available(iOS 18, macOS 15.0, tvOS 18.0, watchOS 11.0, *) {
                return .alwaysByFew
            } else {
                return .automatic
            }
        case .alwaysByOne:
            if #available(iOS 18, macOS 15.0, tvOS 18.0, watchOS 11.0, *) {
                return .alwaysByOne
            } else {
                return .automatic
            }
        case .never:
            return .never
        }
    }
}
