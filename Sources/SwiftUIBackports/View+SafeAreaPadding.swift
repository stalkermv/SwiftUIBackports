//
//  View+SafeAreaPadding.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 30.08.2024.
//

import SwiftUI
import SwiftUIBackportModifiers

extension View {

    /// Adds the provided insets into the safe area of this view.
    ///
    /// Use this modifier when you would like to add a fixed amount
    /// of space to the safe area a view sees.
    ///
    ///     ScrollView(.horizontal) {
    ///         HStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// See the ``View/safeAreaInset(edge:alignment:spacing:content)``
    /// modifier for adding to the safe area based on the size of a
    /// view.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @available(iOS, deprecated: 17, message: "Use native SwiftUI API instead")
    nonisolated public func safeAreaPadding(_ insets: EdgeInsets) -> some View {
        let modifier = SafeAreaPaddingBackportModifier(insets: insets)
        return self.modifier(modifier)
    }


    /// Adds the provided insets into the safe area of this view.
    ///
    /// Use this modifier when you would like to add a fixed amount
    /// of space to the safe area a view sees.
    ///
    ///     ScrollView(.horizontal) {
    ///         HStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// See the ``View/safeAreaInset(edge:alignment:spacing:content)``
    /// modifier for adding to the safe area based on the size of a
    /// view.
    /// 
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @available(iOS, deprecated: 17, message: "Use native SwiftUI API instead")
    nonisolated public func safeAreaPadding(_ edges: Edge.Set = .all, _ length: CGFloat) -> some View {
        let insets = EdgeInsets(
            top: edges.contains(.top) ? length : 0,
            leading: edges.contains(.leading) ? length : 0,
            bottom: edges.contains(.bottom) ? length : 0,
            trailing: edges.contains(.trailing) ? length : 0
        )
        
        let modifier = SafeAreaPaddingBackportModifier(insets: insets)
        return self.modifier(modifier)
    }


    /// Adds the provided insets into the safe area of this view.
    ///
    /// Use this modifier when you would like to add a fixed amount
    /// of space to the safe area a view sees.
    ///
    ///     ScrollView(.horizontal) {
    ///         HStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 ItemView(item)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// See the ``View/safeAreaInset(edge:alignment:spacing:content)``
    /// modifier for adding to the safe area based on the size of a
    /// view.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @available(iOS, deprecated: 17, message: "Use native SwiftUI API instead")
    nonisolated public func safeAreaPadding(_ length: CGFloat) -> some View {
        let insets = EdgeInsets(
            top: length,
            leading: length,
            bottom: length,
            trailing: length
        )
        
        let modifier = SafeAreaPaddingBackportModifier(insets: insets)
        return self.modifier(modifier)
    }

}
