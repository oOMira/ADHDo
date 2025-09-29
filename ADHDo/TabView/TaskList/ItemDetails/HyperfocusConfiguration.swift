//
//  HyperfocusConfiguration.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 13.10.25.
//

import Foundation
import Combine
import SwiftUI

// TODO: clean up

/// Manages a simple countdown used for a "hyperfocus" mode on a task.
///
/// The object publishes two pieces of state:
/// - `hyperFocusOn`: a boolean that indicates whether hyperfocus is active,
/// - `remainingTime`: the remaining countdown time in seconds.
///
/// Use `startTimer(remainingTime:)` to begin a countdown. The timer will tick
/// once per second and update `remainingTime`. When the countdown reaches zero
/// the timer is cancelled and `hyperFocusOn` becomes `false`.
///
/// The class is an `ObservableObject` so views can observe changes via
/// `@ObservedObject` / `@StateObject` and update the UI accordingly.
class HyperFocusConfiguration: ObservableObject {
    /// Whether hyperfocus mode is currently active.
    @Published var hyperFocusOn = false

    /// Remaining countdown time in seconds. Fractional values are supported,
    /// but the timer decrements by 1.0 on each tick.
    @Published var remainingTime = 0.0

    var timer: AnyCancellable?

    deinit {
        stopTimer()
    }

    /// Start a countdown timer for the given number of seconds.
    ///
    /// - Parameter remainingTime: initial countdown value in seconds.
    ///
    /// Calling `startTimer` while a timer is already running will cancel the
    /// previous timer and begin a fresh countdown.
    func startTimer(remainingTime: Double) {
        // ensure we operate on the main actor for UI-updates if called from background
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.stopTimer()
            self.remainingTime = max(0.0, remainingTime)

            // If requested duration is zero, simply ensure state is correct and return
            guard self.remainingTime > 0 else {
                self.hyperFocusOn = false
                return
            }

            self.hyperFocusOn = true

            self.timer = Timer
                .publish(every: 1.0, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }

                    if self.remainingTime > 1 {
                        // decrement keeping non-negative
                        self.remainingTime -= 1.0
                        self.hyperFocusOn = true
                    } else {
                        // last tick: end the session and cancel the timer
                        self.remainingTime = 0.0
                        self.hyperFocusOn = false
                        self.stopTimer()
                    }
                }
        }
    }

    /// Stop and cancel the active timer (if any) and mark hyperfocus as off.
    func stopTimer() {
        timer?.cancel()
        timer = nil
        DispatchQueue.main.async { [weak self] in
            self?.hyperFocusOn = false
        }
    }
}
