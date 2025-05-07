//
//  Created by Valeriy Malishevskyi on 05.09.2023.
//

import SwiftUI

@available(iOS 15.0, *)
struct ContentUnavailableBackportLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 16) {
            configuration.icon
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
                .frame(width: 50)
            
            configuration.title
                .font(.title2.bold())
        }
    }
}

#Preview {
    return VStack {
        Label("Title 1", systemImage: "star")
        Label("Title 2", systemImage: "square")
        Label("Title 3", systemImage: "circle")
    }
    .labelStyle(ContentUnavailableBackportLabelStyle())
}
