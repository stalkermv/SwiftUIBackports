import Testing
@testable import SwiftUIBackports
import SwiftUI

@MainActor
struct SwiftUIBackportsCompileSmokeTests {
    @Test("compile-safe backport surface remains available on macOS")
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func compileSafeViewModifiers() {
        let view = AnyView(
            Color.red
                .containerRelativeFrame(.horizontal)
                .toolbarTitleDisplayMode(ToolbarTitleDisplayModeBackport.automatic)
                .onScrollVisibilityChange { _ in }
        )

        #expect(type(of: view) == AnyView.self)
    }
}
