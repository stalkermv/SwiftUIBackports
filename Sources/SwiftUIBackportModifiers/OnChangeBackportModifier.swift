//
//  OnChangeBackportModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 08.10.2024.
//

import SwiftUI

public struct OnChangeBackportModifier<V: Equatable> : ViewModifier {
    let value: V
    let initial: Bool
    let action: (V, V) -> Void
    
    public init(value: V, initial: Bool, action: @escaping (V, V) -> Void) {
        self.value = value
        self.initial = initial
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            content.onChange(of: value, initial: initial, action)
        } else {
            content
                .onAppear {
                    guard initial else { return }
                    action(value, value)
                }
                .onChange(of: value) { [oldValue = value] newValue in
                    action(oldValue, newValue)
                }
        }
    }
}
