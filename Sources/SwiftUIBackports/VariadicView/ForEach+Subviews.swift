import SwiftUI

public typealias Subview = _VariadicView_Children.Element
public typealias Subviews = _VariadicView_Children

extension ForEach {
    @MainActor
    public init<V: View, C: View>(
        subviews view: V,
        @ViewBuilder content: @escaping (Subview) -> C
    ) where Data == ForEachSubviewCollection<V>, Content == ForEachSubview<V, C>, ID == Int {
        self.init(ForEachSubviewCollection(view), id: \.id) { view in
            ForEachSubview(root: { view.content }, content: content)
        }
    }
    
    @MainActor
    public init<V: View, C: View>(
        subviewsOf view: V,
        @ViewBuilder content: @escaping (Subview) -> C
    ) where Data == ForEachSubviewCollection<V>, Content == ForEachSubview<V, C>, ID == Int {
        self.init(subviews: view, content: content)
    }
}

public struct ForEachSubview<Root: View, Content: View>: View {
    let root: () -> Root
    let content: (Subview) -> Content
    
    init(root: @escaping () -> Root, content: @escaping (Subview) -> Content) {
        self.root = root
        self.content = content
    }
    
    public var body: some View {
        _VariadicView.Tree(
            MultiViewRoot(views: makeIterator),
            content: root
        )
    }
    
    private func makeIterator(_ subviews: Subviews) -> some View {
        ForEach(subviews) { subview in
            content(subview)
        }
    }
}

fileprivate struct MultiViewRoot<Content: View> : _VariadicView_MultiViewRoot {
    let views: (_VariadicView.Children) -> Content

    func body(children: _VariadicView.Children) -> some View {
        views(children)
    }
}

public struct ForEachSubviewCollection<Content: View> : RandomAccessCollection, Identifiable {
    public var id: Int { 0 }
    
    let root: IdentifiedViewContainer<Content>
    
    init(_ root: Content) {
        self.root = IdentifiedViewContainer(id: 0, content: root)
    }
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { 1 }
    
    public subscript(position: Int) -> IdentifiedViewContainer<Content> {
        root
    }
}

public struct IdentifiedViewContainer<Content: View> : Identifiable {
    public let id: Int
    let content: Content
}
