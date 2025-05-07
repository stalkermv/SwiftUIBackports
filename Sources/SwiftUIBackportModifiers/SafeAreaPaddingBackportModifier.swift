//
//  SafeAreaPaddingBackportModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 30.08.2024.
//

import SwiftUI

public struct SafeAreaPaddingBackportModifier: ViewModifier {
    let insets: EdgeInsets
    
    nonisolated public init(insets: EdgeInsets = .init()) {
        self.insets = insets
    }
    
    public func body(content: Content) -> some View {
        if #available (iOS 17.0, *) {
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
