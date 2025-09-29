//
//  EditCategoryView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 07.10.25.
//

// TODO: Cleanup

import SwiftUI
import SwiftData

/// A view for listing and editing user-defined `Category` objects.
///
/// `EditCategoryView` shows an optional "Add New Category" section and a list
/// of existing categories. It supports entering an edit mode (via the
/// navigation bar EditButton) which enables deletion of categories.
///
/// - Note: The view reads and writes to the provided `ModelContext` via the
///   environment. Deletions immediately call `modelContext.delete(...)` and
///   attempt to save the context.
struct EditCategoryView: View {
    @State var showsAddNewCategory: Bool = false
    @State private var editMode: EditMode = .inactive
    @Environment(\.modelContext) private var modelContext

    var categories: [Category]

    var body: some View {
        NavigationStack {
            List {
                // Add Section
                // Hides when entering edit mode
                if !editMode.isEditing || categories.isEmpty {
                    Section {
                        if showsAddNewCategory || categories.isEmpty {
                            AddNewCategoryView(cancelable: !categories.isEmpty,
                                               cancelAction: changeAddSectionVisibility)
                        }
                    } header: {
                        if showsAddNewCategory {
                            Text("New Category")
                        }
                    } footer: {
                        if !showsAddNewCategory && !categories.isEmpty {
                            AddNewCategoryButton(action: changeAddSectionVisibility)
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }

                // Categories section
                if !categories.isEmpty {
                    Section(.categoriesSectionTitle, content: {
                        ForEach(categories, id: \.self) { category in
                            CategoryCell(isEditMode: editMode.isEditing, category: category)
                        }
                        .onDelete { indexSet in
                            withAnimation {
                                indexSet.forEach { modelContext.delete(categories[$0]) }
                                try? modelContext.save()
                                if categories.isEmpty { editMode = .inactive }
                            }
                        }
                    })
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .navigationTitle(categories.isEmpty
                             ? .addCategoryNavigationBarTitle
                             : .editCategoriesNavigationBarTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    DismissButton()
                }
                if !categories.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
    }

    /// Toggle the visibility of the add-new-category section.
    ///
    /// This helper toggles `showsAddNewCategory` with animation. If there are
    /// no categories available the function returns early because the add
    /// section is always visible when the list is empty.
    func changeAddSectionVisibility() {
        guard !categories.isEmpty else { return }
        withAnimation { showsAddNewCategory.toggle() }
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let editCategoriesNavigationBarTitle: Self = .init("Edit Categories")
    static let addCategoryNavigationBarTitle: Self = .init("Add Category")
    static let categoriesSectionTitle: Self = .init("Categories")
}

// MARK: - View Components

/// A footer button shown when the Add section is collapsed and there are existing categories.
private struct AddNewCategoryButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Add New Category")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical)
        .controlSize(.large)
        .buttonStyle(.bordered)
        .listRowSeparator(.hidden)
        .listRowInsets(.init())
    }
}

// MARK: - Preview

#if DEBUG
struct EditCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButtonView(text: "Category", action: { })
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
