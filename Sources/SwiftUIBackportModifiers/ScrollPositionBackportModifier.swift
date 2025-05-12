//
//  ScrollPositionBackportModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 28.09.2024.
//

import SwiftUI

public struct ScrollPositionBackportModifier<ID: Hashable>: ViewModifier {
    let id: Binding<ID?>
    let anchor: UnitPoint?
    
    public init(id: Binding<ID?>, anchor: UnitPoint?) {
        self.id = id
        self.anchor = anchor
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            content.scrollPosition(id: id, anchor: anchor)
        } else {
            ScrollViewReader { proxy in
                content
                    .onChange(of: id.wrappedValue) { value in
                        guard let value = value else { return }
                        withAnimation {
                            proxy.scrollTo(value, anchor: anchor ?? .center)
                        }
                    }
            }
        }
    }
}
