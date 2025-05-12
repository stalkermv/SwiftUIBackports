//
//  ScrollTargetLayoutBackportModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 28.09.2024.
//

import SwiftUI

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
