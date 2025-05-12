//
//  SelectionDisabledModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 14.08.2024.
//

import SwiftUI

public struct SelectionDisabledModifier: ViewModifier {
    private var isDisabled: Bool
    
    public init(isDisabled: Bool) {
        self.isDisabled = isDisabled
    }
    public func body(content: Content) -> some View {
        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
            content
                .selectionDisabled(isDisabled)
                ._trait(SelectionDisabledTraitKey.self, isDisabled)
        } else {
            content
                ._trait(SelectionDisabledTraitKey.self, isDisabled)
        }
    }
}

public struct SelectionDisabledTraitKey: _ViewTraitKey {
    public static let defaultValue: Bool = false
}

#Preview {
    Text("Hello, world!")
        .modifier(SelectionDisabledModifier(isDisabled: true))
}
