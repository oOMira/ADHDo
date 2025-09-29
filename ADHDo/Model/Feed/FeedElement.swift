//
//  FeedElement.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 19.11.25.
//

import Foundation

/// A single element that can appear in the app's feed UI.
///
/// The feed is composed of a sequence of `FeedElement` values. Each element
/// represents either user content (a `ToDoItem`), an invisible placeholder
/// version of the same content (used for spacing/visibility rules), or an
/// advertisement element identified by a `UUID`.
///
/// - Note: `FeedElement` is `Hashable` so it can be used in collections and
///   diffable SwiftUI lists. The enum intentionally stores references to
///   `ToDoItem` entities to preserve object identity for UI updates.
enum FeedElement: Hashable {
    /// A visible content element backed by a `ToDoItem`.
    case content(ToDoItem)

    /// A placeholder content element for the same `ToDoItem` when the item is
    /// intentionally rendered as invisible (e.g., sabotaging item).
    case invisibleContent(ToDoItem)

    /// An advertisement element. The associated `UUID` uniquely identifies the ad
    /// so it can be differentiated from content elements.
    case advert(AdvertConfiguration)
}

// MARK: - Identifiable

extension FeedElement: Identifiable {
    /// A stable identifier for the feed element suitable for use with SwiftUI
    /// lists and diffing. Content-based identifiers include the underlying
    /// `ToDoItem`'s UUID; adverts use their own UUID.
    var id: String {
        switch self {
        case .content(let item), .invisibleContent(let item):
            return "item-\(item.id.uuidString)"
        case .advert(let uuid):
            return "ad-\(uuid.id.uuidString)"
        }
    }
}

// MARK: - Helper

extension FeedElement {
    /// If this element represents content (visible or invisible), return the
    /// underlying `ToDoItem`. For adverts this property returns `nil`.
    var item: ToDoItem? {
        switch self {
        case .content(let item), .invisibleContent(let item):
            return item
        case .advert:
            return nil
        }
    }
}

extension FeedElement: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
