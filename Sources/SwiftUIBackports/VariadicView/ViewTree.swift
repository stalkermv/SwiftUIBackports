//
//  Created by Valeriy Malishevskyi on 27.08.2023.
//

import SwiftUI

/// A view that composes multiple child views into a tree structure.
///
/// `ViewTree` provides a way to structure and organize multiple views in a hierarchical manner. It uses SwiftUI's internal `_VariadicView` to achieve this.
///
/// - Note: This is a more advanced SwiftUI component and is best used when you need fine-grained control over the composition of views.
public struct ViewTree<Content: View, ViewsContent: View>: View {
    
    let content: () -> Content
    let views: (_VariadicView.Children) -> ViewsContent
    
    /// Initializes a new `ViewTree` with the provided content and child views.
    ///
    /// - Parameters:
    ///   - content: The main content of the `ViewTree`.
    ///   - views: A closure that returns the child views of the `ViewTree`.
    public init(_ content: Content, @ViewBuilder views: @escaping (_VariadicView.Children) -> ViewsContent) {
        self.content = { content }
        self.views = views
    }
    
    /// Initializes a new `ViewTree` with the provided content and child views.
    ///
    /// - Parameters:
    ///   - content: A closure that returns the main content of the `ViewTree`.
    ///   - views: A closure that returns the child views of the `ViewTree`.
    public init(@ViewBuilder _ content: @escaping () -> Content, @ViewBuilder views: @escaping (_VariadicView.Children) -> ViewsContent) {
        self.content = content
        self.views = views
    }
    
    public var body: some View {
        _VariadicView.Tree(
            MiliViewRoot(views: views),
            content: content
        )
    }
}

fileprivate struct MiliViewRoot<Content: View>: _VariadicView_MultiViewRoot {
    let views: (_VariadicView.Children) -> Content

    func body(children: _VariadicView.Children) -> some View {
        views(children)
    }
}
