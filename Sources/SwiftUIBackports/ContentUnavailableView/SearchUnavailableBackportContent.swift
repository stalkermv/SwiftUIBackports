//
//  Created by Valeriy Malishevskyi on 05.09.2023.
//

import SwiftUI

@available(iOS, deprecated: 17.0, message: "Use the native SwiftUI API.")
@available(macOS, deprecated: 14.0, message: "Use the native SwiftUI API.")
@available(tvOS, deprecated: 17.0, message: "Use the native SwiftUI API.")
@available(watchOS, deprecated: 10.0, message: "Use the native SwiftUI API.")
public struct SearchUnavailableBackportContent {
    public struct Label : View {
        let text: String
        
        init(text: String? = nil) {
            self.text = text ?? ""
        }
        
        public var body: some View {
            SwiftUI.Label(
                text.isEmpty ? "No Results" : "No Results for \"\(text)\"",
                systemImage: "magnifyingglass"
            )
        }
    }

    /// A view that represents the description of a static `ContentUnavailableView.search` view.
    ///
    /// You don't create this type directly. SwiftUI creates it when you build
    /// a search `ContentUnavailableView`.
    public struct Description : View {
        
        public var body: some View {
            Text("Check the spelling or try a new search")
        }
    }

    /// A view that represents the actions of a static `ContentUnavailableView.search` view.
    ///
    /// You don't create this type directly. SwiftUI creates it when you build
    /// a search``ContentUnavailableView``.
    public struct Actions : View {
        public var body: some View {
            EmptyView()
        }
    }
}
