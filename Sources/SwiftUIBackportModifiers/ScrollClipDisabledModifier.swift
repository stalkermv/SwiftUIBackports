//
//  ScrollClipDisabledModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 06.08.2024.
//

import SwiftUI
import SwiftUIIntrospect

public struct ScrollClipDisabledModifier: ViewModifier {
    let isDisabled: Bool
    
    public init(disabled: Bool = true) {
        self.isDisabled = disabled
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.scrollClipDisabled(isDisabled)
        } else {
            content.introspect(.scrollView, on: .iOS(.v16)) { scrollView in
                scrollView.clipsToBounds = !isDisabled
            }
        }
    }
}
