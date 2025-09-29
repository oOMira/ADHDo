//
//  TaskListView+ToDoItemCell.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 21.11.25.
//

import SwiftUI

extension TaskListView {
    /// A single row wrapper that hosts `ToDoItemView` and exposes swipe actions.
    ///
    /// Use this small view to render a single `ToDoItem` inside the task list and
    /// provide the typical actions (watch, favorite, update, delete) as swipe
    /// actions.
    struct ToDoItemCell: View {
        /// The item to render inside the cell.
        let item: ToDoItem

        /// Action invoked when the user taps the leading "Watch" swipe action.
        /// Implementers typically use this to navigate to a detail or mark an item watched.
        let watchAction: () -> Void

        /// Action invoked when the user taps the leading "Favorite" swipe action.
        let favoriteAction: () -> Void

        /// Action invoked when the user taps the trailing destructive delete action.
        let deleteAction: () -> Void

        /// Action invoked when the user taps the trailing update action.
        let updateAction: () -> Void
        
        let tappedAction: () -> Void

        var body: some View {
            ToDoItemView(item: item, saveAction: tappedAction)
                .disabled(false)
                .deleteDisabled(false)
                // Swipe Actions
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    // Watch
                    Button(.watchActionTitle, systemImage: .systemImage.eye.name) {
                        watchAction()
                    }
                    .tint(.yellow)
                    .accessibilityIdentifier(Accessibility.watchButton)

                    // Favorite
                    Button(.favoriteActionTitle, systemImage: .systemImage.star.name) {
                        favoriteAction()
                    }
                    .tint(.orange)
                    .accessibilityIdentifier(Accessibility.favoriteButton)
                }
                .swipeActions(edge: .trailing) {
                    // Delete
                    Button(role: .destructive) {
                        deleteAction()
                    }
                    .accessibilityIdentifier(Accessibility.deleteButton)

                    // Update
                    Button(.updateActionTitle, systemImage: .systemImage.squareAndPencil.name) {
                        updateAction()
                    }
                    .tint(.gray)
                    .accessibilityIdentifier(Accessibility.updateButton)
                }
                .accessibilityIdentifier(Accessibility.row)
        }
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let watchActionTitle: Self = .init("Watch")
    static let favoriteActionTitle: Self = .init("Favorite")
    static let updateActionTitle: Self = .init("Update")
}

// MARK: - Accessibility

private enum Accessibility {
    static let row = "taskList_todoItem_row"
    static let watchButton = "taskList_todoItem_watch"
    static let favoriteButton = "taskList_todoItem_favorite"
    static let deleteButton = "taskList_todoItem_delete"
    static let updateButton = "taskList_todoItem_update"
}

// MARK: - Preview

#if DEBUG
struct ToDoItemCell_Previews: PreviewProvider {
    static var item: ToDoItem {
        .init(title: "Example Task")
    }

    static var previews: some View {
        Group {
            TaskListView.ToDoItemCell(
                item: item,
                watchAction: { print("watch") },
                favoriteAction: { print("favorite") },
                deleteAction: { print("delete") },
                updateAction: { print("update") },
                tappedAction: { }
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("ToDo Item Cell")
        }
    }
}
#endif
