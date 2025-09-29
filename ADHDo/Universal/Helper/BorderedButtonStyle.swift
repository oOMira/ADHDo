//
//  BorderedButtonStyle.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 16.11.25.
//

import SwiftUI

/// A semantic style selector for bordered buttons used across the app.
///
/// Use `BorderedButtonStyle` to express the intended visual importance of a
/// bordered button (prominent vs regular) rather than scattering SwiftUI
/// `ButtonStyle` literals throughout the codebase.
enum BorderedButtonStyle {
    /// A visually prominent bordered button intended for primary actions.
    case prominent

    /// A regular bordered button for secondary actions.
    case regular
}

/// A `ViewModifier` that applies a `BorderedButtonStyle` to a button view.
///
/// This modifier maps the semantic `BorderedButtonStyle` to concrete SwiftUI
/// `buttonStyle` calls. Prefer using the provided `View` convenience method
/// `borderedButtonStyle(_:)` for more readable call sites.
struct BorderedButtonStyleModifier : ViewModifier {
    let style: BorderedButtonStyle

    func body(content: Content) -> some View {
        switch style {
        case .prominent:
            content.buttonStyle(.borderedProminent)
        case .regular:
            content.buttonStyle(.bordered)
        }
    }
}

extension View {
    /// Convenience API to apply a `BorderedButtonStyle` to the view.
    ///
    /// Example:
    ///
    ///     Button("Save") { ... }
    ///         .borderedButtonStyle(.prominent)
    ///
    /// This keeps call sites expressive and prevents duplication of the
    /// underlying `buttonStyle` value.
    func borderedButtonStyle(_ style: BorderedButtonStyle) -> some View {
        modifier(BorderedButtonStyleModifier(style: style))
    }
}
