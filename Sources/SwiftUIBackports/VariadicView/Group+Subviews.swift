//
//  Group+Subviews.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 23.08.2024.
//

import SwiftUI

extension Group {
    @_disfavoredOverload
    @MainActor public init<Base, Result>(
        subviews view: Base,
        @ViewBuilder transform: @escaping (Subviews) -> Result
    ) where Content == GroupElementsOfContent<Base, Result>, Base : View, Result : View {
        self.init {
            GroupElementsOfContent(base: view, transform: transform)
        }
    }
}

public struct GroupElementsOfContent<Base, Result>: View
where Base : View, Result : View {
    let base: Base
    let transform: (Subviews) -> Result
    
    public var body: some View {
        _VariadicView.Tree(
            MultiViewRoot(views: transform),
            content: { base }
        )
    }
}

fileprivate struct MultiViewRoot<Content: View> : _VariadicView_MultiViewRoot {
    let views: (_VariadicView.Children) -> Content

    func body(children: _VariadicView.Children) -> some View {
        views(children)
    }
}
