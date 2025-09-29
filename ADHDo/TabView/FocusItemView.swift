//
//  FocusItemView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 07.10.25.
//

import SwiftUI
import SwiftData

/// A simple detail screen that presents a focused `ToDoItem`.
///
/// `FocusItemView` displays the `ItemDetailsView` for a single task.
struct FocusItemView: View {
    /// The `ToDoItem` to present in the focus view.
    let item: ToDoItem

    var body: some View {
        NavigationStack {
            List {
                ItemDetailsView(item: item)
            }
            .listStyle(.plain)
            .navigationTitle(.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    DismissButton()
                }
            }
        }
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    /// The navigation title for the focus/detail screen.
    static let title: Self = "What you should do"
}

// MARK: - Preview

#if DEBUG
struct FocusItemView_Previews: PreviewProvider {
    static var previews: some View {
        FocusItemView(item: .init(title: "Item"))
            .modelContainer(for: ToDoItem.self, inMemory: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
