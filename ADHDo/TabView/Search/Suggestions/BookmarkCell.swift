//
//  BookmarkCell.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 22.11.25.
//

import SwiftUI

/// A row that renders a `Bookmark` using `BookmarkView` and exposes a
/// context-menu delete action.
///
/// - Parameters:
///   - bookmark: The `Bookmark` model to render.
///   - deleteAction: Closure invoked when the user chooses the Delete action
///     from the context menu.
struct BookmarkCell: View {
    let bookmark: Bookmark
    let deleteAction: () -> Void

    var body: some View {
        BookmarkView(title: bookmark.name, urlString: bookmark.url)
            .contextMenu {
                Button(.delete,
                       systemImage: .systemImage.trash.name,
                       role: .destructive,
                       action: deleteAction)
            }
            .accessibilityIdentifier(Accessibility.row(for: bookmark.id))
            .listRowSeparator(.hidden)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let delete = Self("Delete")
}

// MARK: - Accessibility

private enum Accessibility {
    static func row(for id: UUID) -> String { "bookmark_row_\(id.uuidString)" }
}

// MARK: - Previews

#if DEBUG
struct BookmarkCell_Previews: PreviewProvider {
    static var sample: Bookmark {
        Bookmark(name: "Example", url: "https://example.com")
    }

    static var previews: some View {
        BookmarkCell(bookmark: sample, deleteAction: { print("delete") })
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
