//
//  PresentationBackgroundInteractionBackport.swift
//  Catapult
//
//  Created by Valeriy Malishevskyi on 21.08.2023.
//

import Foundation

@available(iOS, introduced: 15, deprecated: 16.4)
public struct PresentationBackgroundInteractionBackport : Sendable {
    
    enum LargestUndimmedDetent {
        case exact(PresentationDetentReference)
        case none
        case max
        case automatic
    }
    
    var largestUndimmedDetent: LargestUndimmedDetent

    /// The default background interaction for the presentation.
    public static var automatic: Self {
        PresentationBackgroundInteractionBackport(largestUndimmedDetent: .automatic)
    }

    /// People can interact with the view behind a presentation.
    public static var enabled: Self {
        PresentationBackgroundInteractionBackport(largestUndimmedDetent: .max)
    }
    
    /// People can interact with the view behind a presentation up through a
    /// specified detent.
    ///
    /// At detents larger than the one you specify, SwiftUI disables
    /// interaction.
    ///
    /// - Parameter detent: The largest detent at which people can interact with
    ///   the view behind the presentation.
    public static func enabled(upThrough detent: PresentationDetentReference) -> Self {
        PresentationBackgroundInteractionBackport(largestUndimmedDetent: .exact(detent))
    }

    /// People can't interact with the view behind a presentation.
    public static var disabled: Self {
        PresentationBackgroundInteractionBackport(largestUndimmedDetent: .none)
    }
}
