//
//  UpdateToDoItemView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 07.10.25.
//

import SwiftUI
import SwiftData

/// A view that allows editing an existing `ToDoItem`.
///
/// `UpdateToDoItemView` presents a preview of the current and edited item
/// states and provides expandable editors for individual properties: date,
/// title, subtitle and category. Changes are persisted to the environment
/// `ModelContext` explicitly by calling `modelContext.save()`; property editor
/// actions return `ExpandableView.CompletionState` to communicate success or
/// an error message to the caller UI.
struct UpdateToDoItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var previewType: PreviewType = .new
    @State private var item: ToDoItem

    let categories: [SelectionOption<Category>]
    
    /// Initialize the editor view with the existing item and available categories.
    /// - Parameters:
    ///   - item: The `ToDoItem` to edit.
    ///   - categories: Available `Category` models for selection.
    init(item: ToDoItem, categories: [Category]) {
        self.item = item
        self.categories = [.none] + categories.map { .option($0) }
        let selection = item.category?.asSelectionOption ?? .none
        self.oldSelection = selection
        self.newSelection = selection
        self.newTimestamp = item.timestamp
        self.newTitle = item.title
        self.newSubtitle = item.subtitle ?? .init()
    }

    @State private var previewSectionExpanded: Bool = true

    @State private var dateExpanded: Bool = false
    @State private var newTimestamp: Date

    @State private var titleExpanded: Bool = false
    @State private var newTitle: String

    @State private var subtitleExpanded: Bool = false
    @State private var newSubtitle: String

    // MARK: - Category

    @State private var categoryExpanded: Bool = false
    @State private var oldSelection: SelectionOption<Category>?
    @State private var newSelection: SelectionOption<Category>

    var body: some View {
        List {
            Section(isExpanded: $previewSectionExpanded) {
                PreviewToDoItemCell(oldItem: .from(item),
                                    newItem: .init(timestamp: newTimestamp,
                                                   title: newTitle,
                                                   subtitle: newSubtitle,
                                                   favorite: item.favorite,
                                                   done: item.done))
            } header: {
                HStack {
                    Text(.previewSectionTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(previewSectionExpanded ? "Hide" : "Show") {
                        withAnimation {
                            previewSectionExpanded.toggle()
                        }
                    }
                }

            }

            Section(.editSectionTitle) {
                ExpandableEditCell(expanded: $dateExpanded,
                                   oldDate: $item.timestamp.optional,
                                   newDate: $newTimestamp,
                                   title: .dateTitle,
                                   subtitle: item.timestamp.formatted(date: .numeric, time: .shortened).localizedStringKey,
                                   saveAction: { item.timestamp = newTimestamp; return .success })
                ExpandableEditCell(expanded: $titleExpanded,
                                   oldText: $item.title.optional,
                                   newText: $newTitle,
                                   title: .titleTitle,
                                   saveAction: { item.title = newTitle; return .success })
                ExpandableEditCell(expanded: $subtitleExpanded,
                                   oldText: $item.subtitle,
                                   newText: $newSubtitle,
                                   title: .descriptionTitle,
                                   saveAction: { item.subtitle = newSubtitle; return .success })
                ExpandableEditCell(expanded: $categoryExpanded,
                                   options: categories,
                                   oldSelection: $oldSelection,
                                   newSelection: $newSelection,
                                   title: .categoryTitle,
                                   saveAction: { item.category = newSelection.option; return .success })
                Toggle(.favoriteToggleTitle, isOn: $item.favorite)
                    .fontWeight(.semibold)
                Toggle(.doneToggleTitle, isOn: $item.done)
                    .fontWeight(.semibold)
            }
        }
        .onChange(of: item.done) {
            try? modelContext.save()
        }
        .onChange(of: item.favorite) {
            try? modelContext.save()
        }
        .navigationTitle(.topBarTitle)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(.saveButtonTitle) {
                    if !newTitle.isEmpty {
                        item.title = newTitle
                        item.subtitle = newSubtitle.isEmpty ? nil : newSubtitle
                    }
                    item.subtitle = newSubtitle.isEmpty ? nil : newSubtitle
                    item.timestamp = newTimestamp
                    item.category = newSelection.option
                    try? modelContext.save()
                    dismiss()
                }
                .disabled(newTitle.isEmpty)
            }
        }
    }
}

// MARK: - Helpers

// MARK: UpdateToDoItemView

extension UpdateToDoItemView {
    private func saveTitle() async -> ExpandableView.CompletionState {
        guard !newTitle.isEmpty else { return .failure("Title cannot be empty.") }
        item.title = newTitle
        return saveModelContextForPropertyUpdate()
    }

    private func saveSubtitle() async -> ExpandableView.CompletionState {
        item.subtitle = newSubtitle.isEmpty ? nil : newSubtitle
        return saveModelContextForPropertyUpdate()
    }

    private func saveDate() async -> ExpandableView.CompletionState {
        item.timestamp = newTimestamp
        return saveModelContextForPropertyUpdate()
    }

    private func saveCategory() async -> ExpandableView.CompletionState {
        item.category = newSelection.option
        return saveModelContextForPropertyUpdate()
    }

    private func saveModelContextForPropertyUpdate() -> ExpandableView.CompletionState {
        do { try modelContext.save() }
        catch { return .failure(error.localizedDescription) }
        return .success
    }
}

// MARK: Extensions

private extension Category {
    var asSelectionOption: SelectionOption<Category> {
        .option(self)
    }
}

private extension PreviewToDoItemCell.ItemConfiguration {
    static func from(_ item: ToDoItem) -> Self {
        .init(timestamp: item.timestamp,
              title: item.title,
              subtitle: item.subtitle,
              favorite: item.favorite,
              done: item.done)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let previewTypeTitle: Self = .init("Preview Type")
    static let saveButtonTitle: Self = .init("Save")
    static let editSectionTitle: Self = .init("Edit")
    static let previewSectionTitle: Self = .init("Preview")
    static let topBarTitle: Self = .init("Update")
    static let dateTitle: Self = .init("Date")
    static let titleTitle: Self = .init("Title")
    static let descriptionTitle: Self = .init("Description")
    static let categoryTitle: Self = .init("Category")
    static let favoriteToggleTitle: Self = .init("Favorite")
    static let doneToggleTitle: Self = .init("Done")
}

// MARK: - Preview

#if DEBUG
struct UpdateToDoItemView_Previews: PreviewProvider {
    static var sampleItem: ToDoItem { ToDoItem(title: "Sample Task") }

    static var previews: some View {
        UpdateToDoItemView(item: sampleItem, categories: [])
            .modelContainer(for: ToDoItem.self, inMemory: true)
    }
}
#endif
