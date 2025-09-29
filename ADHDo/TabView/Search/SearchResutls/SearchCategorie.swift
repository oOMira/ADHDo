//
//  SearchCategorie.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 03.11.25.
//

import SwiftUI

/// Represents the filter categories available in the Search UI.
///
/// Each case provides a localized key (via `CustomLocalizedStringKeyConvertible`) and
/// can be iterated using `CaseIterable`. Use the `accessibilityIdentifier` property
/// to get a stable identifier for UI tests.
enum SearchCategorie: LocalizedStringKey, CaseIterable {
    /// Show results from all sections.
    case all = "All"

    /// Show only to-do items.
    case toDo = "ToDo"

    /// Show only completed/done items.
    case done = "Done"
}

// MARK: - SearchCategorie+Identifiable

extension SearchCategorie: Identifiable {
    /// Identity of the category used when iterating or diffing collections.
    var id: Self { self }
}

// MARK: - SearchCategorie+Accessibility

extension SearchCategorie {
    var accessibilityIdentifier: String {
        return "Search.Categorie.\(id)"
    }
}

// MARK: - SearchCategorie+CustomLocalizedStringKeyConvertible

extension SearchCategorie: CustomLocalizedStringKeyConvertible {
    /// Convert the enum case into a `LocalizedStringKey` for display in SwiftUI.
    var localizedStringKey: LocalizedStringKey { self.rawValue }
}
