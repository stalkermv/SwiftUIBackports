//
//  Created by Valeriy Malishevskyi on 04.09.2023.
//

import SwiftUI
import SwiftUIBackportModifiers

extension View {
    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a
    /// value changing, such as an `Environment` key or a `Binding`.
    ///
    /// The system may call the action closure on the main actor, so avoid
    /// long-running tasks in the closure. If you need to perform such tasks,
    /// detach an asynchronous background task.
    ///
    /// When the value changes, the new version of the closure will be called,
    /// so any captured values will have their values from the time that the
    /// observed value has its new value. The old and new observed values are
    /// passed into the closure. In the following code example, `PlayerView`
    /// passes both the old and new values to the model.
    /// ``` swift
    /// struct PlayerView: View {
    ///     var episode: Episode
    ///     @State private var playState: PlayState = .paused
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Text(episode.title)
    ///             Text(episode.showTitle)
    ///             PlayButton(playState: $playState)
    ///         }
    ///         .onChange(of: playState) { oldState, newState in
    ///             model.playStateDidChange(from: oldState, to: newState)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - initial: Whether the action should be run when this view initially
    ///     appears.
    ///   - action: A closure to run when the value changes.
    ///   - oldValue: The old value that failed the comparison check (or the
    ///     initial value when requested).
    ///   - newValue: The new value that failed the comparison check.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    @backDeployed(before: iOS 17)
    public func onChange<V>(
        of value: V,
        initial: Bool = false,
        _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void
    ) -> ModifiedContent<Self, OnChangeBackportModifier<V>> where V : Equatable {
        modifier(OnChangeBackportModifier(value: value, initial: initial, action: action))
    }
}

extension View {
    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a
    /// value changing, such as an `Environment` key or a `Binding`.
    ///
    /// The system may call the action closure on the main actor, so avoid
    /// long-running tasks in the closure. If you need to perform such tasks,
    /// detach an asynchronous background task.
    ///
    /// When the value changes, the new version of the closure will be called,
    /// so any captured values will have their values from the time that the
    /// observed value has its new value. In the following code example,
    /// `PlayerView` calls into its model when `playState` changes model.
    /// ```swift
    /// struct PlayerView: View {
    ///     var episode: Episode
    ///     @State private var playState: PlayState = .paused
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Text(episode.title)
    ///             Text(episode.showTitle)
    ///             PlayButton(playState: $playState)
    ///         }
    ///         .onChange(of: playState) {
    ///             model.playStateDidChange(state: playState)
    ///         }
    ///     }
    /// }
    /// ```
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - initial: Whether the action should be run when this view initially
    ///     appears.
    ///   - action: A closure to run when the value changes.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    @backDeployed(before: iOS 17)
    public func onChange<V>(of value: V, initial: Bool = false, _ action: @escaping () -> Void) -> ModifiedContent<Self, OnChangeBackportModifier<V>>
    where V : Equatable {
        modifier(OnChangeBackportModifier(value: value, initial: initial, action: { _, _ in action() }))
    }
}
