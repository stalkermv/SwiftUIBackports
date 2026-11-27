//
//  TabViewPageClipDisabledModifier.swift
//  SwiftUIBackports
//
//  Created by Valeriy Malishevskyi on 15.11.2024.
//

import SwiftUI
#if USE_SWIFTUI_INTROSPECT
import SwiftUIIntrospect
#endif

public struct TabViewPageClipDisabledModifier: ViewModifier {
    let isDisabled: Bool
    
    public init(disabled: Bool = true) {
        self.isDisabled = disabled
    }
    
    public func body(content: Content) -> some View {
        #if USE_SWIFTUI_INTROSPECT && os(iOS)
        content
            .introspect(
                .tabView(style: .page),
                on: .iOS(.v17),
                .iOS(.v18),
                .iOS(.v26)
            ) { scrollView in
            scrollView.clipsToBounds = !isDisabled
        }
        #elseif USE_SWIFTUI_INTROSPECT && os(macOS)
        content.introspect(.tabView, on: .macOS(.v14, .v15)) { tabView in
            tabView.clipsToBounds = !isDisabled
        }
        #else
        // Without the SwiftUIIntrospect trait, and on platforms other than iOS and macOS
        // (tvOS, visionOS, watchOS), the content is returned unchanged.
        content
        #endif
    }
}
