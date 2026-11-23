//
//  PresentationCornerRadiusModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 06.09.2024.
//

import SwiftUI

@available(iOS, deprecated: 16.4, message: "Use the native SwiftUI API.")
@available(macOS, deprecated: 13.3, message: "Use the native SwiftUI API.")
@available(tvOS, deprecated: 16.4, message: "Use the native SwiftUI API.")
@available(watchOS, deprecated: 9.4, message: "Use the native SwiftUI API.")
public struct PresentationCornerRadiusModifier: ViewModifier {
    let cornerRadius: CGFloat?
    
    public init(cornerRadius: CGFloat?) {
        self.cornerRadius = cornerRadius
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 16.4, macOS 13.4, tvOS 17.4, watchOS 10.4, *) {
            content
                .presentationCornerRadius(cornerRadius)
        } else {
            content
        }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(PresentationCornerRadiusModifier(cornerRadius: 12))
}
