//
//  SearchResult.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 22.11.25.
//

import Foundation

/// A lightweight model representing a single search result item shown in the Search UI.
///
/// Use `SearchResult` to decode static fixtures (for previews) or to represent
/// items returned by your search engine. The model is `Codable` so it can be
/// loaded from JSON bundles and `Identifiable` so it can be used directly in
/// SwiftUI lists.
///
/// Example:
///
///     let result = SearchResult(name: "Flat Earth", description: "Highly suspicious theory")
///     Text(result.name)
///
struct SearchResult: Codable, Identifiable {
    /// Stable identifier for SwiftUI lists and UI tests.
    /// Generated automatically when the model is created.
    let id = UUID()

    /// The display name / title of the search result.
    var name: String

    /// A short descriptive text shown below the title.
    var description: String

    /// Coding keys used when decoding/encoding from JSON bundles.
    /// Note: `id` is intentionally omitted from coding keys because it is
    /// generated locally rather than read from the JSON fixture.
    enum CodingKeys: String, CodingKey {
        case name
        case description
    }

    /// Create a new `SearchResult` with the provided title and description.
    /// - Parameters:
    ///   - name: The title shown in the UI.
    ///   - description: A short, human-readable description.
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }

    /// Decoder initializer used by `Codable` when loading from JSON.
    /// This respects the `CodingKeys` above and will throw if required fields
    /// are missing or of an unexpected type.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
    }
}
