//
//  AdvertConfiguration.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 30.11.25.
//
import Foundation

/// Simple configuration model representing a single advert/promoted item
/// displayed in the task list.
///
/// `AdvertConfiguration` is a lightweight, value-type model used to build
/// demo sponsored rows in the task list. It conforms to `Identifiable` and
/// `Hashable` so it can be used directly in SwiftUI lists and sets.
struct AdvertConfiguration: Identifiable, Hashable {
    let id = UUID()

    /// The timestamp associated with the advert. Use a UTC-based start-of-day
    /// `Date` when constructing demo adverts to avoid timezone ambiguity.
    let date: Date

    let title: String
    let description: String
}
