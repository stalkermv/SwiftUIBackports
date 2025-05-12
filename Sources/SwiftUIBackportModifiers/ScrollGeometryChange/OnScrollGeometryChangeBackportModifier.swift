//
//  OnScrollGeometryChangeBackportModifier.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 01.10.2024.
//
#if canImport(UIKit)
import SwiftUI
import SwiftUIIntrospect

@available(iOS, introduced: 14.0, deprecated: 18.0)
public struct OnScrollGeometryChangeBackportModifier<T: Equatable> : ViewModifier {
    private let type: T.Type
    private let transform: (ScrollGeometry) -> T
    private let action: (_ oldValue: T, _ newValue: T) -> Void
    
    public init(type: T.Type, transform: @escaping (ScrollGeometry) -> T, action: @escaping (_ oldValue: T, _ newValue: T) -> Void) {
        self.type = type
        self.transform = transform
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .onScrollGeometryChange(
                    for: type,
                    of: {
                        transform(
                            .init(
                                contentOffset: $0.contentOffset,
                                contentSize: $0.contentSize,
                                contentInsets: $0.contentInsets,
                                containerSize: $0.containerSize
                            )
                        )
                    },
                    action: action
                )
        } else {
            content.modifier(ScrollGeometryProxyWrapper(transform: transform, action: action))
        }
    }
}

@available(iOS, introduced: 14.0, deprecated: 18.0)
struct ScrollGeometryProxyWrapper<T>: ViewModifier where T: Equatable {
    let transform: (ScrollGeometry) -> T

    let action: (_ oldValue: T, _ newValue: T) -> Void
    
    @State private var manager = ObservationManager<T>()
    
    init(
        transform: @escaping (ScrollGeometry) -> T,
        action: @escaping (_ oldValue: T, _ newValue: T) -> Void
    ) {
        self.transform = transform
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
                DispatchQueue.main.async {
                    manager.observe(scrollable: scrollView, transform, action)
                }
            }
    }
}

private struct OnChangeModifier<V: Equatable> : ViewModifier {
    let value: V
    let action: (V, V) -> Void
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: value) { [oldValue = value] newValue in
                action(oldValue, newValue)
            }
    }
}

import Combine

@MainActor private final class ObservationManager<T: Equatable> {

    private(set) var geometry = ScrollGeometry() {
        didSet {
            guard oldValue != geometry else { return }
            value = transform?(geometry)
        }
    }
    
    private var value: T? {
        didSet {
            guard let value = value, let oldValue = oldValue else { return }
            guard oldValue != value else { return }
            action?(oldValue, value)
        }
    }
    
    private var collectionObservationCancelable: AnyCancellable?
    private var scrollViewObservationCancelable: AnyCancellable?
    
    private var observingCollectionIdentifier: ObjectIdentifier?
    private var observingScrollViewIdentifier: ObjectIdentifier?
    
    private var transform: ((ScrollGeometry) -> T)?
    private var action: ((_ oldValue: T, _ newValue: T) -> Void)?
    
    func observe(
        scrollable: UIScrollView,
        _ transform: @escaping (ScrollGeometry) -> T,
        _ action: @escaping (_ oldValue: T, _ newValue: T) -> Void
    ) {
        self.transform = transform
        self.action = action
        
        let className = String(describing: type(of: scrollable))
        if (className == "PagingCollectionView" || className == "UICollectionView"), let collectionView = scrollable as? UICollectionView {
            observeCollectionView(collectionView)
        } else {
            observeScrollView(scrollable)
        }
    }
    
    private func observeCollectionView(_ collectionView: UICollectionView) {
        let options: NSKeyValueObservingOptions = [.initial, .new]
        let objectIdentifier = ObjectIdentifier(collectionView)
        
        guard observingCollectionIdentifier != objectIdentifier else { return }
        observingCollectionIdentifier = objectIdentifier
        
        collectionObservationCancelable = collectionView.publisher(for: \.contentOffset, options: options)
            .removeDuplicates()
            .throttle(for: 0.05, scheduler: DispatchQueue.main, latest: true)
            .receive(on: RunLoop.main)
            .sink { [weak self, weak collectionView] contentOffset in
                guard let collectionView = collectionView else { return }
                self?.updateObservable(from: collectionView)
            }
    }
    
    private func observeScrollView(_ scrollView: UIScrollView) {
        guard observingScrollViewIdentifier != ObjectIdentifier(scrollView) else { return }
        
        observingScrollViewIdentifier = ObjectIdentifier(scrollView)
        
        let options: NSKeyValueObservingOptions = [.initial, .new]
        
        let contentOffset = scrollView.publisher(for: \.contentOffset, options: options)
        let contentSize   = scrollView.publisher(for: \.contentSize, options: options)
        let contentInsets = scrollView.publisher(for: \.adjustedContentInset, options: options)
        
        let boundsSize = scrollView.publisher(for: \.bounds, options: options)
            .map { $0.size }
        
        scrollViewObservationCancelable = Publishers
            .CombineLatest4(contentOffset, contentSize, contentInsets, boundsSize)
            .map { [weak scrollView] _, _, _, _ -> ScrollGeometry in
                guard let scrollView else { fatalError("Weak reference to scrollView failed!") }
                
                let insets = scrollView.adjustedContentInset
                let bounds = scrollView.bounds
                return ScrollGeometry(
                    contentOffset: scrollView.contentOffset,
                    contentSize: scrollView.contentSize,
                    contentInsets: .init(
                        top: insets.top,
                        leading: insets.left,
                        bottom: insets.bottom,
                        trailing: insets.right
                    ),
                    containerSize: CGSize(
                        width: bounds.width - (insets.left + insets.right),
                        height: bounds.height - (insets.top + insets.bottom)
                    )
                )
            }
            .removeDuplicates()
            .throttle(for: 0.01, scheduler: DispatchQueue.main, latest: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newGeometry in
                self?.geometry = newGeometry
            }
    }
    
    private func updateObservable(from collectionView: UICollectionView) {
        guard !collectionView.isDecelerating, !collectionView.isDragging else {
            return
        }
        
        for cell in collectionView.visibleCells {
            if let scrollView = cell.findScrollView() {
                return observeScrollView(scrollView)
            }
        }
    }
}

extension UICollectionViewCell {
    func findScrollView() -> UIScrollView? {
        return findScrollViewRecursive(self)
    }
    
    private func findScrollViewRecursive(_ view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }
        
        return view.subviews.first.flatMap(findScrollViewRecursive)
    }
}
#endif
