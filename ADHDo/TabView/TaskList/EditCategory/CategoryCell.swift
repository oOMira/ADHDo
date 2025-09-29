//
//  CategoryCell.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 30.11.25.
//

import SwiftUI
import SwiftData

/// A list row that renders and optionally edits a single `Category` in the
/// Edit Category screen.
///
/// The cell displays the category title and an inline editor when the row is
/// toggled into edit mode. Changes are persisted to the provided
/// `ModelContext` when the save action is invoked.
///
struct CategoryCell: View {
    /// Whether the surrounding list is currently in edit mode. When `true`
    /// per-row edit controls are hidden and the inline editor is disabled.
    var isEditMode: Bool
    
    let category: Category
    /// Local state that controls whether this cell is currently in editing mode.
    /// Toggling this shows a `TextField` allowing the name to be changed.
    @State var isEditingCell: Bool = false
    
    @State var newName: String
    @Environment(\.modelContext) private var modelContext

    /// Initialize a `CategoryCell`.
    /// - Parameters:
    ///   - isEditMode: `true` when the surrounding list is in editing mode.
    ///   - category: The `Category` instance to display and edit.
    init(isEditMode: Bool, category: Category) {
        self.isEditMode = isEditMode
        self.category = category
        self.newName = category.name
    }

    var body: some View {
        HStack {
            if isEditingCell && !isEditMode {
                TextField("Category name", text: $newName)
            } else {
                CategoryButtonView(text: category.name) { }
            }
            Spacer()
            if !isEditMode {
                EditModeButton(editing: $isEditingCell, cancelAction: {
                    // Revert local edit buffer to the persisted name
                    newName = category.name
                }, saveAction: {
                    // Persist the edited name back to the model and save
                    category.name = newName
                    try? modelContext.save()
                })
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct CategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CategoryCell(isEditMode: false, category: Category(name: "Groceries"))
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Non-editing mode")
            CategoryCell(isEditMode: true, category: Category(name: "Work"))
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("edit mode")
        }
        .padding()
    }
}
#endif
