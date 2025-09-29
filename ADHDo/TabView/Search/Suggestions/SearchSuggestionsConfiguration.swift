//
//  SearchSuggestionsConfiguration.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 03.11.25.
//

import SwiftUI

/// Lightweight model describing a single suggestion shown on the Suggestions screen.
///
/// This struct is intentionally simple: it carries a unique `id`, display
/// `color`, a localized `title` and a localized `description` to be used by
/// suggestion rows and detail views. It conforms to `Identifiable` and
/// `Hashable`.
struct SearchSuggestionsConfiguration: Identifiable, Hashable {
    let id = UUID()
    let color: Color
    let title: LocalizedStringKey
    let description: LocalizedStringKey

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension SearchSuggestionsConfiguration {
    static let defaultConfig: [Self] = [
        .init(color: .red,
              title: "First Element Title",
              description: "First Element Description"),
    ]
}
