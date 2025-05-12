//
//  TabViewPageClipDisabledModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 15.11.2024.
//

import SwiftUI
import SwiftUIIntrospect

public struct TabViewPageClipDisabledModifier: ViewModifier {
    let isDisabled: Bool
    
    public init(disabled: Bool = true) {
        self.isDisabled = disabled
    }
    
    public func body(content: Content) -> some View {
        #if os(iOS)
        content.introspect(.tabView(style: .page), on: .iOS(.v16), .iOS(.v17), .iOS(.v18)) { scrollView in
            scrollView.clipsToBounds = !isDisabled
        }
        #elseif os(macOS)
        content.introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15)) { tabView in
            tabView.clipsToBounds = !isDisabled
        }
        #endif
    }
}
