//
//  Binding+Invert.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 19.10.25.
//

import SwiftUI

/// Utilities for boolean `Binding` values.
///
/// This file provides a convenience computed property to create an "inverted"
/// `Binding<Bool>` from an existing binding. The inverted binding presents the
/// logical negation of the original binding's value and writes the inverted value
/// back to the source binding.
///
/// Example:
///
///     @State private var isVisible = true
///     var body: some View {
///         Toggle("Hidden", isOn: $isVisible.inverted)
///     }
///
/// In this example the toggle is bound to the negated value of `isVisible`.
extension Binding where Value == Bool {
    /// A binding that exposes the logical inverse of the original `Binding<Bool>`.
    ///
    /// - Read behavior: returns `!wrappedValue`.
    /// - Write behavior: writing a boolean to the returned binding sets the
    ///   underlying binding to the logical negation of the provided value.
    var inverted: Binding<Bool> {
        Binding<Bool>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}
