//
//  AddToDoItemView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 14.10.25.
//

import SwiftUI
import SwiftData
import Combine

/// A view that presents a form for creating a new to-do item.
/// It allows the user to set the item's date, title, subtitle, and category.
/// The view validates the input and shows issues if the input is not valid.
struct AddToDoItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    /// Available category options for the picker shown when creating an item.
    /// The array contains a `.none` selection followed by the provided categories
    let categories: [SelectionOption<Category>]
    
    /// Configuration that controls the date editor inside the form.
    /// Holds the currently selected `newValue`, the previous `oldValue` and the
    /// expanded/collapsed state for the editor UI.
    @StateObject private var dateConfig = {
        let date = Date()
        return UpdateTaskPropertyConfiguration(expanded: false, oldValue: date, newValue: date)
    }()

    /// Configuration for the title editor. Starts expanded by default so the
    /// user can immediately enter a title when creating a new item.
    @StateObject private var titleConfig = {
        UpdateTaskPropertyConfiguration(expanded: true, oldValue: nil, newValue: "")
    }()

    /// Configuration for the subtitle editor. This is optional and starts
    /// collapsed by default.
    @StateObject private var subtitleConfig = {
        UpdateTaskPropertyConfiguration(expanded: false, oldValue: nil, newValue: "")
    }()

    /// Configuration for the category selection editor. Backed by
    /// `SelectionOption<Category>` values and starts collapsed.
    @StateObject private var selectionConfig = {
        UpdateTaskPropertyConfiguration(expanded: false, oldValue: nil, newValue: SelectionOption<Category>.none)
    }()
    
    /// Array of issue messages to show in the issues section. Populated when
    /// validation fails (for example when the title is empty).
    @State var issues = [String]()
    
    /// Create a new `AddToDoItemView` with the available categories.
    /// - Parameter categories: The list of `Category` models to show in the picker.
    init(categories: [Category]) {
        self.categories = [.none] + categories.map { .option($0) }
    }

    var body: some View {
        NavigationStack {
            List {
                // MARK: Issue section
                if !issues.isEmpty {
                    Section(.issueSectionTitle) {
                        ForEach(issues, id: \.self) {
                            ToDoItemIssueView(description: "\($0)")
                        }
                    }
                }
                
                // MARK: Preview section
                Section(.previewSectionTitle) {
                    PreviewToDoItemCell(oldItem: nil, newItem: .init(timestamp: dateConfig.newValue,
                                                                     title: titleConfig.newValue,
                                                                     subtitle: subtitleConfig.newValue,
                                                                     favorite: false,
                                                                     done: false))
                }
                
                // MARK: Edit properties section
                Section(content: {
                    let date = dateConfig.oldValue ?? dateConfig.newValue
                    let formattedDate = date.formatted(date: .numeric, time: .shortened)
                    ExpandableEditCell(expanded: $dateConfig.expanded,
                                       oldDate: $dateConfig.oldValue,
                                       newDate: $dateConfig.newValue,
                                       title: .dateTitle,
                                       subtitle: formattedDate.localizedStringKey,
                                       saveAction: dateConfig.save)
                    ExpandableEditCell(expanded: $titleConfig.expanded,
                                       oldText: $titleConfig.oldValue,
                                       newText: $titleConfig.newValue,
                                       title: .titleTitle,
                                       subtitle: $titleConfig.oldValue.wrappedValue?.localizedStringKey,
                                       saveAction: titleConfig.save)
                    ExpandableEditCell(expanded: $subtitleConfig.expanded,
                                       oldText: $subtitleConfig.oldValue,
                                       newText: $subtitleConfig.newValue,
                                       title: .subtitleTitle,
                                       subtitle: subtitleConfig.oldValue?.localizedStringKey,
                                       saveAction: subtitleConfig.save)
                    ExpandableEditCell(expanded: $selectionConfig.expanded,
                                       options: categories,
                                       oldSelection: $selectionConfig.oldValue,
                                       newSelection: $selectionConfig.newValue,
                                       title: .categoryTitle,
                                       subtitle: selectionConfig.oldValue?.localizedStringKey,
                                       saveAction: selectionConfig.save)
                }, header: {
                    Text(.editSectionTitle)
                }, footer: {
                    Text(.requiredHint)
                })
                
                // MARK: Add item section
                
                Section(content: { EmptyView() }, footer: {
                    Button {
                        guard !titleConfig.newValue.isEmpty else {
                            return withAnimation { issues = ["Title field cannot be empty."] }
                        }
                        saveItem()
                    } label: {
                        Text(.addButtonTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    .listRowInsets(.init())
                    .padding(.bottom)
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .listRowSeparator(.hidden)
                })
            }
            .navigationTitle(.navigationBarTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    DismissButton()
                }
            }
        }
    }
}

// MARK: - Helper

// MARK: AddToDoItemView+Helper

extension AddToDoItemView {
    /// Persist a new `ToDoItem` using the current editor configuration.
    ///
    /// The function collects the current values from the editor configurations
    /// (date, title, subtitle, and category), creates a `ToDoItem`, inserts it
    /// into the `ModelContext` and saves the context. On success the view
    /// dismisses itself.
    private func saveItem() {
        let title = titleConfig.oldValue ?? titleConfig.newValue
        let subtitleFromNew = subtitleConfig.newValue.isEmpty ? nil : subtitleConfig.newValue
        let subtitle = subtitleConfig.oldValue ?? subtitleFromNew
        let category = selectionConfig.oldValue?.option ?? selectionConfig.newValue.option
        let item: ToDoItem = .init(timestamp: dateConfig.newValue,
                                   title: title,
                                   subtitle: subtitle,
                                   category: category)
        modelContext.insert(item)
        try? modelContext.save()
        dismiss()
    }
}

// MARK: Extensions+Helper

extension Category: CustomLocalizedStringKeyConvertible {
    var localizedStringKey: LocalizedStringKey { .init(name) }
}

extension String {
    var localizedStringKey: LocalizedStringKey { .init(self) }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let navigationBarTitle: Self = .init("Add new item")
    // Section title
    static let issueSectionTitle: Self = .init("Issues")
    static let previewSectionTitle: Self = .init("Preview")
    static let editSectionTitle: Self = .init("Edit")
    // Properties title
    static let dateTitle: Self = .init("Date*")
    static let titleTitle: Self = .init("Title*")
    static let subtitleTitle: Self = .init("Subtitle")
    static let categoryTitle: Self = .init("Category")
    // Hints
    static let requiredHint: Self = .init("* marked fields are required")
    // Button title
    static let addButtonTitle: Self = .init("Add item")
}

// MARK: - Preview

#if DEBUG
struct AddToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddToDoItemView(categories: [])
    }
}
#endif
