//
//  Text+Init (Format).swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 15.09.2024.
//

import SwiftUI

extension Text {
    @_disfavoredOverload
    @available(iOS, deprecated: 15.0, message: "Use the native SwiftUI API.")
    @available(macOS, deprecated: 12.0, message: "Use the native SwiftUI API.")
    @available(tvOS, deprecated: 15.0, message: "Use the native SwiftUI API.")
    @available(watchOS, deprecated: 8.0, message: "Use the native SwiftUI API.")
    public init<F>(_ input: F.FormatInput, format: F)
    where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == AttributedString {
        let string = format.format(input)
        self.init(string)
    }
}
