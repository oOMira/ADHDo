//
//  RepeatingTimer.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 20.11.25.
//

import SwiftUI
import Combine

// TODO: Add tests

/// A view modifier that runs a closure on a repeating timer while the view is visible.
///
/// Use this modifier to perform lightweight periodic work (for example: updating
/// a badge, rotating content, or polling an in-memory state) while the modified
/// view is on-screen. The timer is created on `onAppear` and automatically
/// cancelled on `onDisappear` to avoid background activity and retain cycles.
///
/// Example:
/// ```swift
/// Text("Hello")
///     .repeatingTimer(every: 5) {
///         // do periodic work every 5 seconds
///     }
/// ```
struct RepeatingTimer: ViewModifier {
    /// Internal cancellable used to keep the timer subscription alive.
    @State private var badgeTimer: AnyCancellable?

    /// Interval between timer firings, in seconds.
    let timerInterval: TimeInterval

    /// Action executed each time the timer fires.
    let timerAction: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                badgeTimer = Timer.publish(every: timerInterval, on: .main, in: .common)
                    .autoconnect()
                    .sink(receiveValue: { _ in
                        timerAction()
                    })
            }
            .onDisappear {
                badgeTimer = nil
            }
    }
}

extension View {
    /// Attach a repeating timer to this view that fires the provided action.
    ///
    /// - Parameters:
    ///   - interval: Time interval in seconds between firings.
    ///   - action: Closure to run each time the timer fires.
    ///
    /// The returned view will start the timer when it appears and cancel it when
    /// it disappears.
    func repeatingTimer(every interval: TimeInterval, action: @escaping () -> Void) -> some View {
        modifier(RepeatingTimer(timerInterval: interval, timerAction: action))
    }
}
