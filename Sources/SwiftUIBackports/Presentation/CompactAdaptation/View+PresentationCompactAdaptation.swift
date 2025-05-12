//
//  View+PresentationCompactAdaptation.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 04.09.2024.
//

import SwiftUI

extension View {
    /// Specifies how to adapt a presentation to compact size classes.
    ///
    /// Some presentations adapt their appearance depending on the context. For
    /// example, a sheet presentation over a vertically-compact view uses a
    /// full-screen-cover appearance by default. Use this modifier to indicate
    /// a custom adaptation preference. For example, the following code
    /// uses a presentation adaptation value of ``PresentationAdaptation/none``
    /// to request that the system not adapt the sheet in compact size classes:
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
    ///                     .presentationCompactAdaptation(.none)
    ///             }
    ///         }
    ///     }
    ///
    /// If you want to specify different adaptations for each dimension,
    /// use the ``View/presentationCompactAdaptation(horizontal:vertical:)``
    /// method instead.
    ///
    /// - Parameter adaptation: The adaptation to use in either a horizontally
    ///   or vertically compact size class.
    @available(iOS, introduced: 15, deprecated: 16.4, message: "Use `View.presentationCompactAdaptation(_:)` instead.")
    @_disfavoredOverload
    @ViewBuilder public func presentationCompactAdaptation(_ adaptation: PresentationAdaptationBackport) -> some View {
        if #available(iOS 16.4, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            self.presentationCompactAdaptation(adaptation.backportValue)
        } else {
            #if os(iOS)
            self.modifier(PresentationCompactAdaptationModifier(adaptation: adaptation))
            #elseif os(macOS)
            let _ = print("PresentationCompactAdaptation is not available on macOS.")
            EmptyView()
            #endif
        }
    }
}

public enum PresentationAdaptationBackport : Sendable {

    /// Use the default presentation adaptation.
    case automatic

    /// Don't adapt for the size class, if possible.
    case none

    /// Prefer a popover appearance when adapting for size classes.
    case popover

    /// Prefer a sheet appearance when adapting for size classes.
    case sheet

    /// Prefer a full-screen-cover appearance when adapting for size classes.
    case fullScreenCover
    
    @available(iOS 16.4, macOS 13.3, tvOS 17.0, watchOS 10.0, *)
    var backportValue: PresentationAdaptation {
        switch self {
        case .automatic:
            return .automatic
        case .none:
            return .none
        case .popover:
            return .popover
        case .sheet:
            return .sheet
        case .fullScreenCover:
            return .fullScreenCover
        }
    }
}

#if canImport(UIKit)
@available(iOS, introduced: 15, deprecated: 16.4)
public struct PresentationCompactAdaptationModifier: ViewModifier {
    let adaptation: PresentationAdaptationBackport
    
    public init(adaptation: PresentationAdaptationBackport) {
        self.adaptation = adaptation
    }
    
    public func body(content: Content) -> some View {
        content.background {
            CompactAdaptationView(adaptation: adaptation)
        }
    }
}

@available(iOS, introduced: 15, deprecated: 16.4)
private struct CompactAdaptationView: UIViewControllerRepresentable {

    let adaptation: PresentationAdaptationBackport

    func makeUIViewController(context: Context) -> CompactAdaptationViewController {
        let result = CompactAdaptationViewController()
        result.adaptation = adaptation
        
        return result
    }

    func updateUIViewController(_ controller: CompactAdaptationViewController, context: Context) {
        controller.adaptation = adaptation
    }
}

@available(iOS, introduced: 15, deprecated: 16.4)
private class CompactAdaptationViewController: UIViewController {

    var adaptation: PresentationAdaptationBackport!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateAdaptation()
    }
    
    func updateAdaptation() {
        switch adaptation! {
        case .none:
            modalPresentationStyle = .none
        case .automatic:
            modalPresentationStyle = .automatic
        case .popover:
            modalPresentationStyle = .popover
        case .sheet:
            modalPresentationStyle = .pageSheet
        case .fullScreenCover:
            modalPresentationStyle = .fullScreen
        }
    }
}
#endif
