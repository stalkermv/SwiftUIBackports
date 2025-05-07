//
//  Created by Valeriy Malishevskyi on 27.08.2023.
//

import SwiftUI

public typealias TraitValueKey = _ViewTraitKey

extension Subview {
    @MainActor @preconcurrency public var traitValues: TraitCollectionValues {
        TraitCollectionValues(self)
    }
}
 
@MainActor public struct TraitCollectionValues {
    
    static let traitsKey = "traits"
    static let traitsStorageKey = "storage"
    static let tagKey = "tagged"
    
    let element: Subview
    
    var values: [Any] {
        return Mirror(reflecting: element)
            .descendant(Self.traitsKey, Self.traitsStorageKey) as? [Any] ?? []
    }
    
    init(_ element: Subview) {
        self.element = element
    }

    /// Accesses the particular trait value associated with a custom key.
    ///
    /// Create custom trait values by defining a key
    /// that conforms to the ``TraitValueKey`` protocol, and then using that
    /// key with the subscript operator of the ``ContainerValues`` structure
    /// to get and set a value for that key:
    ///
    /// ```
    /// private struct MyCustomKey: TraitValueKey {
    ///     static let defaultValue: String = "Default value"
    /// }
    ///
    /// extension TraitCollectionValues {
    ///     var myCustomValue: String {
    ///         get { self[MyCustomKey.self] }
    ///         set { self[MyCustomKey.self] = newValue }
    ///     }
    /// }
    /// ```
    ///
    /// You use custom trait values the same way you use system-provided
    /// values, setting a value with the ``View/traitValue(_:_:)`` view
    /// modifier, and reading values from a ``Subview`` provided by the
    /// `subviews` modifier. You can also provide a dedicated view modifier as a
    /// convenience for setting the value:
    ///
    /// ```
    /// extension View {
    ///     func myCustomValue(_ myCustomValue: String) -> some View {
    ///         traitValue(MyCustomKey.self, myCustomValue)
    ///     }
    /// }
    /// ```
    public subscript<Key>(key: Key.Type) -> Key.Value
    where Key : TraitValueKey {
        return element[key]
    }

    /// The tag value for the given type if the container values contains one.
    ///
    /// Tag values are set using the ``View/tag`` modifier.
    ///
    /// - Parameter type: The type to get the tag value for.
    /// - Returns: The tag value for the given type if the subview has one,
    ///   otherwise `nil`.
    public func tag<V>(for type: V.Type) -> V? where V : Hashable {
        values.compactMap {
            withUnsafePointer(to: Mirror(reflecting: $0).descendant(0, Self.tagKey)) {
                $0.pointee as? AnyHashable
            }
        }.first(where: { $0 is V }) as? V
    }

    /// Returns true if the container values contain a tag matching a given
    /// value.
    ///
    /// Tag values are set using the ``View/tag`` modifier.
    ///
    /// - Parameter tag: The tag value to check for.
    /// - Returns: If the container values has a tag matching the given value.
    public func hasTag<V>(_ tag: V) -> Bool where V : Hashable {
        values.contains {
            withUnsafePointer(to: Mirror(reflecting: $0).descendant(0, Self.tagKey)) {
                $0.pointee as? V
            } == tag
        }
    }
}

extension View {
    /// Sets a particular trait value for a view.
    ///
    /// Use this modifier to set one of the writable properties of the
    /// ``TraitCollectionValues`` structure, including custom values that you
    /// create.
    ///
    /// Trait values are similar to preferences in that they can be read by views
    /// above the view they're set on. However, unlike preferences, trait values
    /// do not have merging behavior and do not escape their closest container. In
    /// the following example, the trait value is set on the contained view, but
    /// is dropped when it reaches the containing ``VStack``.
    ///
    /// ```
    /// VStack {
    ///     Text("A").traitValue(FirstStringValueKey.self, "First Value") // FirstStringValueKey = "First Value"
    ///     Text("B").traitValue(SecondStringValueKey.self, "Second Value") // SecondStringValueKey = "Second Value"
    ///     // Trait values are unaffected by views that aren't containers:
    ///     Text("C").traitValue(FirstStringValueKey.self, "Third Value").padding() // FirstStringValueKey = "Third Value"
    /// } // FirstStringValueKey = its default value, trait values do not escape the container
    /// ```
    ///
    /// Even if a stack has only one child, trait values still won't
    /// be lifted to the `VStack`. Trait values don't escape a container
    /// even if the container has only one child.
    ///
    /// - Parameters:
    ///   - key: The type of the key that indicates the property of the
    ///     ``TraitCollectionValues`` structure to update.
    ///   - value: The new value to set for the item specified by `key`.
    ///
    /// - Returns: A view that has the given value set in its trait values.
    nonisolated public func traitValue<K: TraitValueKey>(_ key: K.Type = K.self, _ value: K.Value) -> some View {
        self._trait(K.self, value)
    }
}
