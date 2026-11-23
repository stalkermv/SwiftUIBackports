//
//  View+presentationCornerRadius.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 06.09.2024.
//

import SwiftUI
import SwiftUIBackportModifiers

extension View {
    /// Requests that the presentation have a specific corner radius.
    ///
    /// Use this modifier to change the corner radius of a presentation.
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents([.medium, .large])
    ///                     .presentationCornerRadius(21)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter cornerRadius: The corner radius, or `nil` to use the system
    ///   default.
    @available(iOS, introduced: 15, deprecated: 16.4, message: "Use `View.presentationCornerRadius(_:)` instead.")
    @_disfavoredOverload
    @available(macOS, deprecated: 13.3, message: "Use the native SwiftUI API.")
    @available(tvOS, deprecated: 16.4, message: "Use the native SwiftUI API.")
    @available(watchOS, deprecated: 9.4, message: "Use the native SwiftUI API.")
    public func presentationCornerRadius(_ cornerRadius: CGFloat?) -> some View {
        let modifier = PresentationCornerRadiusModifier(cornerRadius: cornerRadius)
        return self.modifier(modifier)
    }
}
