//
//  View+ToolbarTitleDisplayMode.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 02.09.2024.
//

#if canImport(UIKit)
import SwiftUI

extension View {

    /// Configures the toolbar title display mode for this view.
    ///
    /// Use this modifier to override the default toolbar title display
    /// mode.
    ///
    ///     NavigationStack {
    ///         ContentView()
    ///             .toolbarTitleDisplayMode(.inlineLarge)
    ///     }
    ///
    /// See ``ToolbarTitleDisplayMode`` for more information on the
    /// different kinds of display modes. This modifier has no effect
    /// on macOS.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    nonisolated public func toolbarTitleDisplayMode(_ mode: ToolbarTitleDisplayModeBackport) -> some View {
        if #available (iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return self.toolbarTitleDisplayMode(mode.backportValue)
        } else {
            return self.navigationBarTitleDisplayMode(mode.navigationTitleDisplayMode)
        }
    }

}

public enum ToolbarTitleDisplayModeBackport {

    /// The automatic mode.
    ///
    /// For root content in a navigation stack in iOS, iPadOS, or tvOS
    /// this behavior will:
    ///   - Default to ``ToolbarTitleDisplayMode/large``
    ///     when a navigation title is configured.
    ///   - Default to ``ToolbarTitleDisplayMode/inline``
    ///     when no navigation title is provided.
    ///
    /// In all platforms, content pushed onto a navigation stack will use the
    /// behavior of the content already on the navigation stack. This
    /// has no effect in macOS.
   case automatic

    /// The large mode.
    ///
    /// In iOS, and watchOS, this displays the toolbar title below the
    /// content of the navigation bar when scrollable content is scrolled
    /// to the top and transitions to the center of the toolbar as
    /// content is scrolled.
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    case large

    /// The inline large mode.
    ///
    /// In iOS, this behavior displays the title as large inside the toolbar
    /// and moves any leading or centered toolbar items into the overflow menu
    /// of the toolbar. This has no effect in macOS.
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case inlineLarge(fallback: NavigationBarItem.TitleDisplayMode = .automatic)

    /// The inline mode.
    ///
    /// In iOS, tvOS, and watchOS this mode displays the title with a
    /// smaller size in the middle of the toolbar. This has no effect
    /// in macOS.
    case inline
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    var backportValue: ToolbarTitleDisplayMode {
        switch self {
        case .automatic:
            return .automatic
        case .large:
            return .large
        case .inlineLarge:
            return .inlineLarge
        case .inline:
            return .inline
        }
    }
    
    var navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode {
        switch self {
        case .automatic:
            return .automatic
        case .large:
            return .large
        case .inlineLarge(let fallback):
            return fallback
        case .inline:
            return .inline
        }
    }
}

#endif
