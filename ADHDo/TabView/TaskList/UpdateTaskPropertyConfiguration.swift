//
//  UpdateTaskPropertyConfiguration.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 27.11.25.
//

import SwiftUI
import Combine

/// A small observable wrapper that holds the editing state for a single
/// editable property of a `ToDoItem`.
///
/// This class centralizes three pieces of state commonly used by the
/// `ExpandableEditCell` UI component:
/// - `expanded`: whether the inline editor is currently open,
/// - `oldValue`: an optional previous value (used to render a preview or to
///   allow cancelling edits), and
/// - `newValue`: the current inline edit buffer value that will be saved.
///
/// The generic parameter `T` represents the property type (for example
/// `String` for a title/subtitle or `Date` for a timestamp).
final class UpdateTaskPropertyConfiguration<T>: ObservableObject {
    /// Whether the editor is currently expanded and visible.
    @Published var expanded: Bool

    /// The previous (persisted) value for the property. If present this may
    /// be used to render a preview or to revert changes when cancelling.
    @Published var oldValue: T?

    /// The working edit value shown to the user while the editor is open.
    @Published var newValue: T

    /// Create a new configuration object.
    /// - Parameters:
    ///   - expanded: Initial expanded state.
    ///   - oldValue: Optional persisted value to show as the original value.
    ///   - newValue: The initial working value.
    init(expanded: Bool, oldValue: T? = nil, newValue: T) {
        self.expanded = expanded
        self.oldValue = oldValue
        self.newValue = newValue
    }

    /// Save the current working value and collapse the editor.
    ///
    /// This method updates the local state: it toggles `expanded` and
    /// assigns `oldValue = newValue`. It is marked `@MainActor` because it
    /// mutates `@Published` properties that are observed by SwiftUI views.
    @MainActor
    func save() async -> ExpandableView.CompletionState {
        withAnimation {
            expanded.toggle()
            oldValue = newValue
        }
        return .success
    }
}
