//
//  View+PresentationBackgroundInteraction.swift
//  Catapult
//
//  Created by Valeriy Malishevskyi on 21.08.2023.
//

#if os(iOS) && compiler(>=5.7)
import SwiftUI

public extension View {
    /// Controls whether people can interact with the view behind a presentation.
    ///
    /// On many platforms, SwiftUI automatically disables the view behind a sheet that you present, so that people can’t interact with the backing view until they dismiss the sheet. Use this modifier if you want to enable interaction.
    ///
    /// The following example enables people to interact with the view behind the sheet when the sheet is at the smallest detent, but not at the other detents:
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var showSettings = false
    ///
    ///     var body: some View {
    ///         Button("View Settings") {
    ///             showSettings = true
    ///         }
    ///         .sheet(isPresented: $showSettings) {
    ///             SettingsView()
    ///                 .presentationDetents(
    ///                     [.height(120), .medium, .large])
    ///                 .presentationBackgroundInteraction(
    ///                     .enabled(upThrough: .height(120)))
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter interaction: A specification of how people can interact with the view behind a presentation.
    /// - Returns: A view modified with the specified presentation background interaction.
    @available(iOS, introduced: 15, deprecated: 16.4)
    @backDeployed(before: iOS 16)
    @_disfavoredOverload
    func presentationBackgroundInteraction(_ interaction: PresentationBackgroundInteractionBackport) ->
    ModifiedContent<Self, PresentationBackgroundInteractionModifier> {
        modifier(PresentationBackgroundInteractionModifier(interaction: interaction))
    }
}

@available(iOS, introduced: 15, deprecated: 16.4)
public struct PresentationBackgroundInteractionModifier: ViewModifier {
    let interaction: PresentationBackgroundInteractionBackport
    
    public init(interaction: PresentationBackgroundInteractionBackport) {
        self.interaction = interaction
    }
    
    public func body(content: Content) -> some View {
        content.background {
            UndimmedDetentView(backgroundInteraction: interaction)
        }
    }
}

@available(iOS, introduced: 15, deprecated: 16.4)
private struct UndimmedDetentView: UIViewControllerRepresentable {

    var backgroundInteraction: PresentationBackgroundInteractionBackport

    func makeUIViewController(context: Context) -> UndimmedDetentViewController {
        let result = UndimmedDetentViewController()
        result.backgroundInteraction = backgroundInteraction
        
        return result
    }

    func updateUIViewController(_ controller: UndimmedDetentViewController, context: Context) {
        controller.backgroundInteraction = backgroundInteraction
    }
}

@available(iOS, introduced: 15, deprecated: 16.4)
private class UndimmedDetentViewController: UIViewController {

    var backgroundInteraction: PresentationBackgroundInteractionBackport!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avoidDimmingParent()
        avoidDisablingControls()
    }

    func avoidDimmingParent() {
        switch backgroundInteraction.largestUndimmedDetent {
        case .exact(let presentationDetentReference):
            sheetPresentationController?.largestUndimmedDetentIdentifier = presentationDetentReference.id
        case .none:
            sheetPresentationController?.largestUndimmedDetentIdentifier = nil
        case .max:
            sheetPresentationController?.largestUndimmedDetentIdentifier = sheetPresentationController?.detents.last?.identifier
        case .automatic:
            break
        }
    }

    func avoidDisablingControls() {
        presentingViewController?.view.tintAdjustmentMode = .normal
    }
}

#endif
