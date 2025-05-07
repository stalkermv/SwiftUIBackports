//
//  View+SensoryFeedback.swift
//  SwiftUIHelpers
//
//  Created by Valeriy Malishevskyi on 01.09.2024.
//

import SwiftUI

extension View {

    /// Plays the specified `feedback` when the provided `trigger` value
    /// changes.
    ///
    /// For example, you could play feedback when a state value changes:
    ///
    ///     struct MyView: View {
    ///         @State private var showAccessory = false
    ///
    ///         var body: some View {
    ///             ContentView()
    ///                 .sensoryFeedback(.selection, trigger: showAccessory)
    ///                 .onLongPressGesture {
    ///                     showAccessory.toggle()
    ///                 }
    ///
    ///             if showAccessory {
    ///                 AccessoryView()
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - feedback: Which type of feedback to play.
    ///   - trigger: A value to monitor for changes to determine when to play.
    nonisolated public func sensoryFeedback<T>(_ feedback: SensoryFeedbackBackport, trigger: T) -> some View where T : Equatable {
        if #available(iOS 17.0, watchOS 8.0, *) {
            return self.sensoryFeedback(feedback.backportValue, trigger: trigger)
        } else {
            return self
        }
    }


    /// Plays the specified `feedback` when the provided `trigger` value changes
    /// and the `condition` closure returns `true`.
    ///
    /// For example, you could play feedback for certain state transitions:
    ///
    ///     struct MyView: View {
    ///         @State private var phase = Phase.inactive
    ///
    ///         var body: some View {
    ///             ContentView(phase: $phase)
    ///                 .sensoryFeedback(.selection, trigger: phase) { old, new in
    ///                     old == .inactive || new == .expanded
    ///                 }
    ///         }
    ///
    ///         enum Phase {
    ///             case inactive
    ///             case preparing
    ///             case active
    ///             case expanded
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - feedback: Which type of feedback to play.
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - condition: A closure to determine whether to play the feedback when
    ///     `trigger` changes.
    nonisolated public func sensoryFeedback<T>(_ feedback: SensoryFeedbackBackport, trigger: T, condition: @escaping (_ oldValue: T, _ newValue: T) -> Bool) -> some View where T : Equatable {
        if #available(iOS 17.0, watchOS 8.0, *) {
            return self.sensoryFeedback(feedback.backportValue, trigger: trigger, condition: condition)
        } else {
            return self
        }
    }


    /// Plays feedback when returned from the `feedback` closure after the
    /// provided `trigger` value changes.
    ///
    /// For example, you could play different feedback for different state
    /// transitions:
    ///
    ///     struct MyView: View {
    ///         @State private var phase = Phase.inactive
    ///
    ///         var body: some View {
    ///             ContentView(phase: $phase)
    ///                 .sensoryFeedback(trigger: phase) { old, new in
    ///                     switch (old, new) {
    ///                         case (.inactive, _): return .success
    ///                         case (_, .expanded): return .impact
    ///                         default: return nil
    ///                     }
    ///                 }
    ///         }
    ///
    ///         enum Phase {
    ///             case inactive
    ///             case preparing
    ///             case active
    ///             case expanded
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - feedback: A closure to determine whether to play the feedback and
    ///     what type of feedback to play when `trigger` changes.
    nonisolated public func sensoryFeedback<T>(trigger: T, _ feedback: @escaping (_ oldValue: T, _ newValue: T) -> SensoryFeedbackBackport?) -> some View where T : Equatable {
        if #available(iOS 17.0, watchOS 8.0, *) {
            return self.sensoryFeedback(trigger: trigger, { feedback($0, $1)?.backportValue })
        } else {
            return self
        }
    }

}

public enum SensoryFeedbackBackport : Equatable, Sendable {

    /// Indicates that a task or action has completed.
    ///
    /// Only plays feedback on iOS and watchOS.
    case success

    /// Indicates that a task or action has produced a warning of some kind.
    ///
    /// Only plays feedback on iOS and watchOS.
    case warning

    /// Indicates that an error has occurred.
    ///
    /// Only plays feedback on iOS and watchOS.
    case error

    /// Indicates that a UI element’s values are changing.
    ///
    /// Only plays feedback on iOS and watchOS.
    case selection

    /// Indicates that an important value increased above a significant
    /// threshold.
    ///
    /// Only plays feedback on watchOS.
    case increase

    /// Indicates that an important value decreased below a significant
    /// threshold.
    ///
    /// Only plays feedback on watchOS.
    case decrease

    /// Indicates that an activity started.
    ///
    /// Use this haptic when starting a timer or any other activity that can be
    /// explicitly started and stopped.
    ///
    /// Only plays feedback on watchOS.
    case start

    /// Indicates that an activity stopped.
    ///
    /// Use this haptic when stopping a timer or other activity that was
    /// previously started.
    ///
    /// Only plays feedback on watchOS.
    case stop

    /// Indicates the alignment of a dragged item.
    ///
    /// For example, use this pattern in a drawing app when the user drags a
    /// shape into alignment with another shape.
    ///
    /// Only plays feedback on iOS and macOS.
    case alignment

    /// Indicates movement between discrete levels of pressure.
    ///
    /// For example, as the user presses a fast-forward button on a video
    /// player, playback could increase or decrease and haptic feedback could be
    /// provided as different levels of pressure are reached.
    ///
    /// Only plays feedback on macOS.
    case levelChange

    /// Indicates a drawn path has completed and/or recognized.
    ///
    /// Use this to provide feedback for closed shape drawing or similar
    /// actions. It should supplement the user experience, since only some
    /// platforms will play feedback in response to it.
    ///
    /// Only plays feedback on iOS.
    case pathComplete

    /// Provides a physical metaphor you can use to complement a visual
    /// experience.
    ///
    /// Use this to provide feedback for UI elements colliding. It should
    /// supplement the user experience, since only some platforms will play
    /// feedback in response to it.
    ///
    /// Not all platforms will play different feedback for different weights and
    /// intensities of impact.
    ///
    /// Only plays feedback on iOS and watchOS.
    case impactWeight(_: Weight = .medium, intensity: Double = 1.0)
    
    public static func impact(weight: Weight = .medium, intensity: Double = 1.0) -> Self {
        .impactWeight(weight, intensity: intensity)
    }

    /// Provides a physical metaphor you can use to complement a visual
    /// experience.
    ///
    /// Use this to provide feedback for UI elements colliding. It should
    /// supplement the user experience, since only some platforms will play
    /// feedback in response to it.
    ///
    /// Not all platforms will play different feedback for different
    /// flexibilities and intensities of impact.
    ///
    /// Only plays feedback on iOS and watchOS.
    case impactFlexibility(_: Flexibility, intensity: Double = 1.0)
    
    public static func impact(flexibility: Flexibility, intensity: Double = 1.0) -> Self {
        .impactFlexibility(flexibility, intensity: intensity)
    }

    /// The weight to be represented by a type of feedback.
    ///
    /// `Weight` values can be passed to
    /// `SensoryFeedback.impact(weight:intensity:)`.
    public enum Weight : Equatable, Sendable {

        /// Indicates a collision between small or lightweight UI objects.
        case light

        /// Indicates a collision between medium-sized or medium-weight UI
        /// objects.
        case medium

        /// Indicates a collision between large or heavyweight UI objects.
        case heavy
        
        @available(iOS 17.0, *)
        var backportValue: SensoryFeedback.Weight {
            switch self {
            case .light:
                return .light
            case .medium:
                return .medium
            case .heavy:
                return .heavy
            }
        }
    }

    /// The flexibility to be represented by a type of feedback.
    ///
    /// `Flexibility` values can be passed to
    /// `SensoryFeedback.impact(flexibility:intensity:)`.
    public enum Flexibility : Equatable, Sendable {

        /// Indicates a collision between hard or inflexible UI objects.
        case rigid

        /// Indicates a collision between solid UI objects of medium
        /// flexibility.
        case solid

        /// Indicates a collision between soft or flexible UI objects.
        case soft
        
        @available(iOS 17.0, *)
        var backportValue: SensoryFeedback.Flexibility {
            switch self {
            case .rigid:
                return .rigid
            case .solid:
                return .solid
            case .soft:
                return .soft
            }
        }
    }
    
    @available(iOS 17.0, *)
    var backportValue: SensoryFeedback {
        switch self {
        case .success:
            return .success
        case .warning:
            return .warning
        case .error:
            return .error
        case .selection:
            return .selection
        case .increase:
            return .increase
        case .decrease:
            return .decrease
        case .start:
            return .start
        case .stop:
            return .stop
        case .alignment:
            return .alignment
        case .levelChange:
            return .levelChange
        case .pathComplete:
            if #available(iOS 17.5, *) {
                return .pathComplete
            } else {
                return .success
            }
        case .impactWeight(let weight, intensity: let intensity):
            return .impact(weight: weight.backportValue, intensity: intensity)
        case .impactFlexibility(let flexibility, intensity: let intensity):
            return .impact(flexibility: flexibility.backportValue, intensity: intensity)
        }
    }
}
