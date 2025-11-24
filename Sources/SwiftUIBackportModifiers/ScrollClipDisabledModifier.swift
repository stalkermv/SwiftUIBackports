//
//  ScrollClipDisabledModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 06.08.2024.
//

import SwiftUI
#if USE_SWIFTUI_INTROSPECT
import SwiftUIIntrospect
#endif

public struct ScrollClipDisabledModifier: ViewModifier {
    let isDisabled: Bool
    
    public init(disabled: Bool = true) {
        self.isDisabled = disabled
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            content.scrollClipDisabled(isDisabled)
        } else {
            #if USE_SWIFTUI_INTROSPECT
            #if os(iOS)
            content.introspect(.scrollView, on: .iOS(.v16)) { scrollView in
                scrollView.clipsToBounds = !isDisabled
            }
            #elseif os(macOS)
            content.introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15)) { scrollView in
                scrollView.clipsToBounds = !isDisabled
            }
            #endif
            #else
            content
            #endif
        }
    }
}
