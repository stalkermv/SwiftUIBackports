//
//  Created by Valeriy Malishevskyi on 05.09.2023.
//

import SwiftUI

@available(iOS 15.0, *)
@MainActor public struct ContentUnavailableView<Label, Description, Actions> : View
where Label : View, Description : View, Actions : View {
    let label: Label
    let description: Description
    let actions: Actions
    
    public init(
        @ViewBuilder label: () -> Label,
        @ViewBuilder description: () -> Description = { EmptyView() },
        @ViewBuilder actions: () -> Actions = { EmptyView() }
    ) {
        self.label = label()
        self.description = description()
        self.actions = actions()
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            VStack {
                label
                    .font(.title2)
                    .labelStyle(ContentUnavailableBackportLabelStyle())
                description
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            actions
                .font(.callout)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    return VStack {
        ContentUnavailableView {
            Text("Label")
        } description: {
            Text("Des")
        } actions: {
            Button("action") { }
            Button("action") { }
        }
        
        ContentUnavailableView {
            Text("Label")
        } description: {
            Text("Des")
        } actions: {
            Button("action") { }
            Button("action") { }
        }
    }
}

@available(iOS 15.0, *)
extension ContentUnavailableView
where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {

    /// Creates an interface, consisting of a title generated from a localized
    /// string, an image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - image: The name of the image resource to lookup.
    ///    - description: The view that describes the interface.
    public init(_ title: LocalizedStringKey, image name: String, description: Text? = nil) {
        self.init {
            Label(title, image: name)
        } description: {
            description
        }
    }

    /// Creates an interface, consisting of a title generated from a localized
    /// string, a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    public init(_ title: LocalizedStringKey, systemImage name: String, description: Text? = nil) {
        self.init {
            Label(title, systemImage: name)
        } description: {
            description
        }
    }

    /// Creates an interface, consisting of a title generated from a string,
    /// an image and additional content, that you display when the content of
    /// your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A string used as the title.
    ///    - image: The name of the image resource to lookup.
    ///    - description: The view that describes the interface.
    public init<S>(_ title: S, image name: String, description: Text? = nil) where S : StringProtocol {
        self.init {
            Label(title, image: name)
        } description: {
            description
        }
    }

    /// Creates an interface, consisting of a title generated from a string,
    /// a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A string used as the title.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    public init<S>(_ title: S, systemImage name: String, description: Text? = nil) where S : StringProtocol {
        self.init {
            Label(title, systemImage: name)
        } description: {
            description
        }
    }
}

@available(iOS 15.0, *)
extension ContentUnavailableView
where Label == SearchUnavailableBackportContent.Label,
      Description == SearchUnavailableBackportContent.Description,
      Actions == SearchUnavailableBackportContent.Actions {

    /// Creates a `ContentUnavailableView` instance that conveys a search state.
    ///
    /// A `ContentUnavailableView` initialized with this static member is expected to
    /// be contained within a searchable view hierarchy. Such a configuration
    /// enables the search query to be parsed into the view's description.
    ///
    /// For example, consider the usage of this static member in *ContactsListView*:
    ///
    ///     struct ContactsListView: View {
    ///         @ObservedObject private var viewModel = ContactsViewModel()
    ///
    ///         var body: some View {
    ///             NavigationStack {
    ///                 List {
    ///                     ForEach(viewModel.searchResults) { contact in
    ///                         NavigationLink {
    ///                             ContactsView(contact)
    ///                         } label: {
    ///                             Text(contact.name)
    ///                         }
    ///                     }
    ///                 }
    ///                 .navigationTitle("Contacts")
    ///                 .searchable(text: $viewModel.searchText)
    ///                 .overlay {
    ///                     if searchResults.isEmpty {
    ///                         ContentUnavailableView.search
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    public static var search: ContentUnavailableView<
        SearchUnavailableBackportContent.Label,
        SearchUnavailableBackportContent.Description,
        SearchUnavailableBackportContent.Actions> {
            return ContentUnavailableView(
                label: { SearchUnavailableBackportContent.Label() },
                description: SearchUnavailableBackportContent.Description.init,
                actions: SearchUnavailableBackportContent.Actions.init
            )
        }

    /// Creates a `ContentUnavailableView` instance that conveys a search state.
    ///
    /// For example, consider the usage of this static member in *ContactsListView*:
    ///
    ///     struct ContactsListView: View {
    ///         @ObservedObject private var viewModel = ContactsViewModel()
    ///
    ///         var body: some View {
    ///             NavigationStack {
    ///                 CustomSearchBar(query: $viewModel.searchText)
    ///                 List {
    ///                     ForEach(viewModel.searchResults) { contact in
    ///                         NavigationLink {
    ///                             ContactsView(contact)
    ///                         } label: {
    ///                             Text(contact.name)
    ///                         }
    ///                     }
    ///                 }
    ///                 .navigationTitle("Contacts")
    ///                 .overlay {
    ///                     if viewModel.searchResults.isEmpty {
    ///                         ContentUnavailableView
    ///                             .search(text: viewModel.searchText)
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter text: The search text query.
    public static func search(text: String) -> ContentUnavailableView<Label, Description, Actions> {
        ContentUnavailableView(
           label: { SearchUnavailableBackportContent.Label(text: text) },
           description: SearchUnavailableBackportContent.Description.init,
           actions: SearchUnavailableBackportContent.Actions.init
       )
    }
}

extension ContentUnavailableView
where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    public init(
        _ title: LocalizedStringKey,
        image: Image,
        description: Text? = nil
    ) {
        self.init {
            Label {
                Text(title)
            } icon: {
                image
            }
        } description: {
            description
        }
    }
}
