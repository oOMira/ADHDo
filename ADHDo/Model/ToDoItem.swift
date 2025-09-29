//
//  Item.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 20.09.25.
//

import Foundation
import SwiftData

/// A SwiftData model representing a single to-do item.
///
/// The `category` relationship is optional so a to-do item can exist without
/// being assigned to a category. When a `Category` is deleted the relationship
/// will be nullified (if the inverse is configured on `Category`).
@Model final class ToDoItem: Identifiable {
    @Attribute(.unique) var id = UUID()

    /// Optional to-one relationship to a `Category` model.
    ///
    /// The inverse is defined on `Category.items` so deleting a category will
    /// nullify this property when the model container applies the delete rule.
    var category: Category?

    /// Creation timestamp for ordering and display.
    var timestamp: Date

    /// Primary title for the to-do item.
    var title: String

    /// Optional subtitle/notes for the item.
    var subtitle: String?

    /// Flag indicating whether the item is marked as favorite.
    var favorite: Bool

    /// Flag indicating whether the item is completed.
    var done: Bool

    init(timestamp: Date = .init(),
         title: String,
         subtitle: String? = nil,
         favorite: Bool = false,
         category: Category? = nil,
         done: Bool = false)
    {
        self.timestamp = timestamp
        self.title =  title
        self.subtitle = subtitle
        self.favorite = favorite
        self.category = category
        self.done = done
    }
}
