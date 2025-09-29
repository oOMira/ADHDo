//
//  AddNewBookmarkView+Subviews.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 22.11.25.
//

import SwiftUI

// MARK: AddNewBookmarkButton
extension AddNewBookmarkView {
    /// Primary add button shown in the form footer.
    ///
    /// The button calls the provided `action` closure when tapped. It uses the
    /// prominent bordered style and expands horizontally to fill the row.
    struct AddNewBookmarkButton: View {
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                Text(.addButtonTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .padding(.vertical, .spacing.large.cgFloat)
            .listRowInsets(.init())
            .accessibilityIdentifier(Accessibility.addButton)
        }
    }
}

// MARK: TextFieldCell
extension AddNewBookmarkView {
    /// A simple labeled text field cell used in the add-bookmark form.
    ///
    /// Shows a headline label (`title`) and a `TextField` bound to `value`.
    struct TextFieldCell: View {
        private let id = UUID()
        let title: LocalizedStringKey
        @Binding var value: String

        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .accessibilityIdentifier(Accessibility.label(for: id))

                TextField(title, text: $value)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.URL)
                    .accessibilityIdentifier(Accessibility.field(for: id))
            }
        }
    }
}

// MARK: - Localized Strings

private extension LocalizedStringKey {
    static let addButtonTitle: Self = .init("Add Bookmark")
}

// MARK: - Accessibility

private enum Accessibility {
    static let addButton = "addBookmark_addButton"
    static func label(for id: UUID) -> String {
        return "addBookmark_label_\(id.uuidString)"
    }
    static func field(for id: UUID) -> String {
        return "addBookmark_field_\(id.uuidString)"
    }
}

#if DEBUG
struct AddNewBookmarkView_Subviews_Previews: PreviewProvider {
    private typealias TextFieldCell = AddNewBookmarkView.TextFieldCell
    private typealias AddButton = AddNewBookmarkView.AddNewBookmarkButton

    static var previews: some View {
        Group {
            TextFieldCell(title: "Title",
                          value: .constant("Example Bookmark"))
            .previewLayout(.sizeThatFits)
            AddNewBookmarkView.AddNewBookmarkButton { }
                .previewLayout(.sizeThatFits)

        }
    }
}
#endif
