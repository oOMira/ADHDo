//
//  BookMark.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 17.11.25.
//

import Foundation
import SwiftData

/// A lightweight SwiftData model representing a saved bookmark (name + URL).
///
/// Use `Bookmark` to persist simple user bookmarks/links used throughout the app.
/// it stores a displayable `name` and the bookmark `url` as a String.
@Model final class Bookmark: Identifiable {
    /// Unique identifier for the bookmark.
    @Attribute(.unique) var id = UUID()

    /// Human-readable display name for the bookmark.
    var name: String

    /// The destination URL as a string. Store as `String` to keep the model
    /// serialization simple; convert to `URL` when opening or validating.
    var url: String

    /// Initialize a new `Bookmark`.
    ///
    /// - Parameters:
    ///   - name: The bookmark's display name.
    ///   - url: The destination URL string (not validated here).
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
