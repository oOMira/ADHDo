//
//  Binding+Optional.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 20.11.25.
//

import SwiftUI

// TODO: Add tests

/// Convenience helpers for working with `Binding` instances.
///
/// This extension provides a small adapter that lets you convert a non-optional
/// `Binding<Value>` into an optional `Binding<Value?>`. It is useful when a
/// view expects an optional binding (for example editable optional fields) but
/// your model exposes a non-optional value.
extension Binding {
    /// An optional view of this binding.
    ///
    /// - Getter: returns the underlying `wrappedValue` promoted to an optional
    ///   (`Value?`).
    /// - Setter: when the optional value is non-`nil` the underlying
    ///   `wrappedValue` is updated. Assigning `nil` is intentionally ignored
    ///   (no-op) because there is no canonical way to convert `nil` into a
    ///   concrete `Value` for the original non-optional binding.
    var optional: Binding<Value?> {
        Binding<Value?>(
            get: { self.wrappedValue },
            set: {
                guard let newValue = $0 else { return }
                self.wrappedValue = newValue
            }
        )
    }
}
