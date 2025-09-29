//
//  Category.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 17.11.25.
//

import Foundation
import SwiftData

/// A simple SwiftData model representing a user-defined category.
///
/// Categories group `ToDoItem` objects and are stored in the ModelContainer.
/// This model declares a to-many inverse relationship (`items`) which points
/// back to `ToDoItem.category`. The relationship uses `deleteRule: .nullify` so
/// when a `Category` is removed the SwiftData runtime will nullify the
/// corresponding `ToDoItem.category` references (items remain, but lose the link).
@Model final class Category: Identifiable, Hashable, Equatable {
    /// Unique identifier for the category.
    @Attribute(.unique) var id = UUID()

    /// Human-readable name for the category.
    var name: String

    /// Inverse to-many relationship for items that reference this category.
    ///
    /// - Note: `deleteRule: .nullify` is applied here so deleting the category
    ///   will set `ToDoItem.category = nil` for related items rather than
    ///   deleting the items themselves.
    @Relationship(deleteRule: .nullify, inverse: \ToDoItem.category) var items: [ToDoItem] = []
    
    /// Create a new `Category` with the provided name.
    ///
    /// - Parameter name: The display name for the category.
    init(name: String) {
        self.name = name
    }
}
