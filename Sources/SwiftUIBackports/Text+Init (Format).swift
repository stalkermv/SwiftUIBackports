//
//  Text+Init (Format).swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 15.09.2024.
//

import SwiftUI

extension Text {
    @_disfavoredOverload
    @available(*, deprecated, message: "Use the native SwiftUI API (iOS 15+).")
    public init<F>(_ input: F.FormatInput, format: F)
    where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == AttributedString {
        let string = format.format(input)
        self.init(string)
    }
}
