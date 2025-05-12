//
//  InvalidatableContentBackportModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 10.09.2024.
//

import SwiftUI

public struct InvalidatableContentBackportModifier: ViewModifier {
    
    let invalidatable: Bool
    
    public func body(content: Content) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return content.invalidatableContent(invalidatable)
        } else {
            return content
                .environment(\.redactionReasons, RedactionReasons(rawValue: 4))
        }
    }
}

public struct SwiftUITestModifier: ViewModifier {
    let test = true

    public func body(content: Content) -> some View {
        content
        .environment(\.accessibilityEnabled, true)
    }
}