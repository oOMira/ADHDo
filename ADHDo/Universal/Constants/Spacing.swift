//
//  CGFloat+Spacing.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 02.11.25.
//

import Foundation

/// Standardized spacing values used across the app.
///
/// Provides named spacing steps with `CGFloat` raw values to encourage
/// consistent layout and padding throughout the UI.
/// Use the `cgFloat` property to retrieve the `CGFloat` value.
enum Spacing: CGFloat {
    /// 2 for very small gap for extreme tight layouts.
    case extraExtraSmall = 2

    /// 4 for slight spacing, typically used for micro-adjustments.
    case extraSmall = 4

    /// 8 for small spacing for compact components.
    case small = 8

    /// 16 for default/medium spacing for most layouts.
    case medium = 16

    /// 32 for larger spacing used for section separation.
    case large = 32

    /// 64 for extra large spacing, for large gaps or full-screen separation.
    case extraLarge = 64

    /// Returns the spacing value as a `CGFloat`.
    var cgFloat: CGFloat { rawValue }
}

// MARK: - Convenience conversion

extension CGFloat {
    /// Expose a `spacing` typealias on `CGFloat`.
    ///
    /// - Note: It's not recommended but it allows for autocompletion to work
    /// and this way avoids code duplication.
    typealias spacing = Spacing
}
