//
//  ContainerRelativeFrame.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 01.08.2024.
//

import SwiftUI

public struct ContainerRelativeFrameModifier: ViewModifier {
    let axes: Axis.Set
    let alignment: Alignment
    let length: (CGFloat, Axis) -> CGFloat
    
    public init(
        axes: Axis.Set,
        alignment: Alignment = .center,
        length: @escaping (CGFloat, Axis) -> CGFloat
    ) {
        self.axes = axes
        self.alignment = alignment
        self.length = length
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .containerRelativeFrame(axes, alignment: alignment, length)
        } else {
            ViewTree({ content }) { children in
                ForEach(children) { child in
                    ContainerRelativeFrameLayout(
                        axes: axes,
                        alignment: alignment,
                        length: length,
                        screenSize: UIScreen.main.bounds.size
                    ) {
                        child
                    }
                }
            }
        }
    }
}

#Preview {
    let modifier = ContainerRelativeFrameModifier(
        axes: .horizontal,
        alignment: .center,
        length: { length, axis in length }
    )
    
    ScrollView(.horizontal) {
        HStack(spacing: 10.0) {
            ForEach(0...1, id: \.self) { _ in
                Rectangle()
                    .fill(Color.blue)
                    .aspectRatio(3.0 / 2.0, contentMode: .fit)
                    .modifier(modifier)
            }
        }
    }
}

fileprivate struct ContainerRelativeFrameLayout: Layout {
    let axes: Axis.Set
    let alignment: Alignment
    let length: (CGFloat, Axis) -> CGFloat
    let screenSize: CGSize

    
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        assert(subviews.count == 1, "expects a single subview")
        
        let resizedProposal = ProposedViewSize(
            width: axes.contains(.horizontal) ? length(screenSize.width, .horizontal) : proposal.width,
            height: axes.contains(.vertical) ? length(screenSize.height, .vertical) : proposal.height
        )

        return subviews[0].sizeThatFits(resizedProposal)
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        assert(subviews.count == 1, "expects a single subview")

        let resizedProposal = ProposedViewSize(
            width: bounds.width,
            height: bounds.height
        )
        
        subviews[0].place(
            at: CGPoint(x: bounds.midX, y: bounds.midY),
            anchor: .center,
            proposal: resizedProposal
        )
    }
}

private struct ViewTree<Content: View, ViewsContent: View>: View {
    
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
