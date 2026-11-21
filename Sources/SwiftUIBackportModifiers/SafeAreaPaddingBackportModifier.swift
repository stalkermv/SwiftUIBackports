//
//  SafeAreaPaddingBackportModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 30.08.2024.
//

import SwiftUI

@available(iOS, deprecated: 17.0, message: "Use the native SwiftUI API.")
@available(macOS, deprecated: 14.0, message: "Use the native SwiftUI API.")
@available(tvOS, deprecated: 17.0, message: "Use the native SwiftUI API.")
@available(watchOS, deprecated: 10.0, message: "Use the native SwiftUI API.")
public struct SafeAreaPaddingBackportModifier: ViewModifier {
    let insets: EdgeInsets
    
    nonisolated public init(insets: EdgeInsets = .init()) {
        self.insets = insets
    }
    
    public func body(content: Content) -> some View {
        if #available (iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            content.safeAreaPadding(insets)
        } else {
            content.padding(insets)
        }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(SafeAreaPaddingBackportModifier(insets: .init()))
}
