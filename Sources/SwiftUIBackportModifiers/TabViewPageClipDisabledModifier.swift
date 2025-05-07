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
        content.introspect(.tabView(style: .page), on: .iOS(.v16), .iOS(.v17), .iOS(.v18)) { scrollView in
            scrollView.clipsToBounds = !isDisabled
        }
    }
}
