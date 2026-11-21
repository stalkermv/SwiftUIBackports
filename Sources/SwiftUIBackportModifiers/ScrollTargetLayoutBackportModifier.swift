//
//  ScrollTargetLayoutBackportModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 28.09.2024.
//

import SwiftUI

@available(iOS, deprecated: 17.0, message: "Use the native SwiftUI API.")
@available(macOS, deprecated: 14.0, message: "Use the native SwiftUI API.")
@available(tvOS, deprecated: 17.0, message: "Use the native SwiftUI API.")
@available(watchOS, deprecated: 10.0, message: "Use the native SwiftUI API.")
public struct ScrollTargetLayoutBackportModifier: ViewModifier {
    let isEnabled: Bool
    
    public init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 17, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            content.scrollTargetLayout(isEnabled: isEnabled)
        } else {
            content
        }
    }
}
