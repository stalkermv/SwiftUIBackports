//
//  PresentationDetentReference.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2022-11-01.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS)
import SwiftUI

/**
 This enum is used to bridge the SwiftUI `PresentationDetent`
 with UIKit `UISheetPresentationController.Detent.Identifier`.
 */
@available(iOS, introduced: 15, deprecated: 16.4)
public enum PresentationDetentReference: Hashable, Comparable, Identifiable, Sendable {

    public var id: UISheetPresentationController.Detent.Identifier {
        uiKitIdentifier
    }
    
    /// The system detent for a sheet at full height.
    case large

    /// The system detent for a sheet that's approximately half the available screen height.
    case medium

    /// A custom detent with the specified fractional height.
    case fraction(_ value: CGFloat)

    ///  A custom detent with the specified height.
    case height(_ value: CGFloat)

    @available(iOS 16.0, *)
    var swiftUIDetent: PresentationDetent {
        switch self {
        case .large: return .large
        case .medium: return .medium
        case .fraction(let value): return .fraction(value)
        case .height(let value): return .height(value)
        }
    }
    
    @available(iOS 15.0, *)
    @MainActor var uiKitDetent: UISheetPresentationController.Detent {
        switch self {
        case .large: return .large()
        case .medium: return .medium()
        case .fraction(let value):
            if #available(iOS 16.0, *) {
                return .custom(identifier: .fraction(value)) { context in
                    context.maximumDetentValue * value
                }
            } else {
                return .medium()
            }
        case .height(let value):
            if #available(iOS 16.0, *) {
                return .custom(identifier: .height(value)) { context in
                    value
                }
            } else {
                return .medium()
            }
        }
    }

    var uiKitIdentifier: UISheetPresentationController.Detent.Identifier {
        switch self {
        case .large: return .large
        case .medium: return .medium
        case .fraction(let value):
            if #available(iOS 16.0, *) {
                return .fraction(value)
            } else {
                return .medium
            }
        case .height(let value):
            if #available(iOS 16.0, *) {
                return .height(value)
            } else {
                return .medium
            }
        }
    }
}

@available(iOS 16.0, *)
extension Collection where Element == PresentationDetentReference {

    var swiftUISet: Set<PresentationDetent> {
        Set(map { $0.swiftUIDetent })
    }
}

@available(iOS 16.0, *)
public extension UISheetPresentationController.Detent.Identifier {

    /// A fraction-specific detent identifier.
    static func fraction(_ value: CGFloat) -> Self {
        .init("Fraction:\(String(format: "%.1f", value))")
    }

    /// A height-specific detent identifier.
    static func height(_ value: CGFloat) -> Self {
        .init("Height:\(value)")
    }
}
#endif
