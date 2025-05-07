//
//  FillShapeStyle.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 01.08.2024.
//

import SwiftUI

extension ShapeStyle where Self == FillShapeStyle {

    /// An overlay fill style for filling shapes.
    ///
    /// This shape style is appropriate for items situated on top of an existing
    /// background color. It incorporates transparency to allow the background
    /// color to show through.
    ///
    /// Use the primary version of this style to fill thin or small shapes, such
    /// as the track of a slider on iOS.
    /// Use the secondary version of this style to fill medium-size shapes, such
    /// as the background of a switch on iOS.
    /// Use the tertiary version of this style to fill large shapes, such as
    /// input fields, search bars, or buttons on iOS.
    /// Use the quaternary version of this style to fill large areas that
    /// contain complex content, such as an expanded table cell on iOS.
    public static var fill: FillShapeStyle {
        FillShapeStyle()
    }
}

public struct FillShapeStyle: ShapeStyleBackport {
    
    public init() {}

    public func resolve(in environment: EnvironmentValues) -> Color {
        Color(.systemFill)
    }
}

public protocol ShapeStyleBackport: ShapeStyle {
    associatedtype Shape: ShapeStyle
    func resolve(in environment: EnvironmentValues) -> Shape
}

extension ShapeStyleBackport {
    public func _apply(to shape: inout SwiftUI._ShapeStyle_Shape) {
        let mirror = Mirror(reflecting: shape)
        
        for child in mirror.children {
            if let label = child.label, label == "environment" {
                if let environment = child.value as? EnvironmentValues {
                    resolve(in: environment)._apply(to: &shape)
                } else {
                    fatalError("Unable to cast environment")
                }
                break
            }
        }
    }
}
