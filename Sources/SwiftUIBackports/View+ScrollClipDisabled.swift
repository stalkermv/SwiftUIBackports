//
//  View+ScrollClipDisabled.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 06.08.2024.
//

import SwiftUI
import SwiftUIBackportModifiers

extension View {
    /// Disables the scroll clipping behavior for this view.
    /// - Parameter disabled: A Boolean value that indicates whether scroll clipping is disabled.
    /// - Returns: A view that disables the scroll clipping behavior.
    ///
    /// - Warning: This method is available only in iOS 17.0 and later. On earlier versions of iOS, this method has no effect.
    @_disfavoredOverload
    @available(iOS, deprecated: 17.0, message: "Use the native SwiftUI API.")
    @available(macOS, deprecated: 14.0, message: "Use the native SwiftUI API.")
    @available(tvOS, deprecated: 17.0, message: "Use the native SwiftUI API.")
    @available(watchOS, deprecated: 10.0, message: "Use the native SwiftUI API.")
    public func scrollClipDisabled(_ disabled: Bool = true) -> some View {
        modifier(ScrollClipDisabledModifier(disabled: disabled))
    }
}
