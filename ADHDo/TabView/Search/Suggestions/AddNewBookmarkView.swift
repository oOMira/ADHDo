//
//  AddNewBookmarkView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 23.10.25.
//

import SwiftUI
import SwiftData

/// A view that allows the user to create and insert a new `Bookmark` into
/// the app's SwiftData model container.
///
/// The view presents two text fields (name and URL) and validates that both
/// are non-empty before inserting a `Bookmark` into the environment
/// `ModelContext`. On successful insertion the view dismisses itself using
/// `Environment(\.dismiss)`.
///
/// Usage:
/// - Present this view modally or on a navigation stack. The view reads the
///   `ModelContext` from the environment to perform the insert.
struct AddNewBookmarkView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var url = ""

    @State private var isShowingAlert = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextFieldCell(title: .nameTitle, value: $name)
                        .accessibilityElement(children: .combine)
                        .accessibilityIdentifier(Accessibility.nameFieldCell)

                    TextFieldCell(title: .urlTitle, value: $url)
                        .accessibilityElement(children: .combine)
                        .accessibilityIdentifier(Accessibility.urlFieldCell)
                } footer: {
                    AddNewBookmarkButton {
                        guard !name.isEmpty, !url.isEmpty else { return isShowingAlert.toggle() }
                        let newBookmark = Bookmark(name: name, url: url)
                        modelContext.insert(newBookmark)
                        dismiss()
                    }
                    .accessibilityIdentifier(Accessibility.addButton)
                }
            }
            .accessibilityIdentifier(Accessibility.list)
            .alert(.missingAlertTitle, isPresented: $isShowingAlert, actions: {
                Button(.missingAlertButtonTitle, role: .cancel) { }
            }, message: {
                return Text(getMissingAlertMessage())
            })
            .navigationTitle(.newBookmarkTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    DismissButton()
                        .accessibilityIdentifier(Accessibility.dismissButton)
                }
            }
        }
    }
}

// MARK: - Helper

private extension AddNewBookmarkView {
    /// Return the appropriate missing-data `LocalizedStringKey` for the
    /// alert message based on which fields are empty.
    ///
    /// - Returns: A `LocalizedStringKey` suitable for `Alert` message text.
    func getMissingAlertMessage() -> LocalizedStringKey {
        if name.isEmpty && url.isEmpty {
            return .missingNameAndURLAlertDescription
        } else if name.isEmpty && !url.isEmpty {
            return .missingNameAlertDescription
        } else if !name.isEmpty && url.isEmpty {
            return .missingURLAlertDescription
        } else {
            return .missingNameAndURLAlertDescription
        }
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let nameTitle: Self = .init("Name")
    static let urlTitle: Self = .init("URL")
    static let newBookmarkTitle: Self = .init("New Bookmark")
    static let missingAlertButtonTitle: Self = .init("OK")
    static let missingAlertTitle: Self = .init("Missing Data")
    static let missingNameAndURLAlertDescription: Self = .init("Please fill in both the name and URL fields before adding a new bookmark.")
    static let missingNameAlertDescription: Self = .init("Please fill in the name before adding a new bookmark.")
    static let missingURLAlertDescription: Self = .init("Please fill in the URL before adding a new bookmark.")
}

// MARK: - Accessibility

private enum Accessibility {
    static let list = "addBookmark_list"
    static let nameFieldCell = "addBookmark_nameField_cell"
    static let urlFieldCell = "addBookmark_urlField_cell"
    static let dismissButton = "addBookmark_dismissButton"
    static let addButton = "addBookmark_addButton"
}

// MARK: - Preview

#if DEBUG
struct AddNewBookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewBookmarkView()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Add Bookmark")
    }
}
#endif
