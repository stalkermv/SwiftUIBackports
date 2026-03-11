//
//  ScrollVisibilityChangeBackportModifier.swift
//  SwiftUIBackports
//
//  Created by Valeriy Malishevskyi on 30.12.2025.
//

import SwiftUI

public struct ScrollVisibilityChangeBackportModifier: ViewModifier {
    let threshold: CGFloat
    let onChange: (Bool) -> Void
    
    public init(
        threshold: CGFloat = 0.5,
        action: @escaping (Bool) -> Void
    ) {
        self.threshold = threshold
        self.onChange = action
    }
    
    public func body(content: Content) -> some View {
        #if canImport(UIKit)
        let bounds = UIScreen.main.bounds
        content
            .onGeometryChange(for: Bool.self) { proxy in
                let safeAreaHeight = bounds.height - proxy.safeAreaInsets.top - proxy.safeAreaInsets.bottom
                let visibleHeight = min(proxy.frame(in: .global).maxY, bounds.height - proxy.safeAreaInsets.bottom) - max(proxy.frame(in: .global).minY, proxy.safeAreaInsets.top)
                let visibility = visibleHeight / safeAreaHeight
                let isVisible = visibility >= 0
                
                return isVisible
            } action: { new in
                onChange(new)
            }
        #else
        content
        #endif
    }
}
