import Testing
@testable import SwiftUIBackports
import SwiftUI

@MainActor
struct SwiftUIBackportsCompileSmokeTests {
    @Test("compile-safe backport surface remains available on macOS")
    func compileSafeViewModifiers() {
        let view = AnyView(
            Color.red
                .tabViewPageClipDisabled()
                .onScrollVisibilityChange { _ in }
        )

        #expect(type(of: view) == AnyView.self)
    }
}
