//
//  NewCategoryView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 15.10.25.
//


import SwiftUI
import SwiftData

/// A screen that allows the user to create a new `Category`.
///
/// `NewCategoryView` shows an optional collapsed/expanded list of existing
/// categories for context and a simple form to enter and save a new category
/// name. The view performs an insert into the environment `ModelContext` and
/// dismisses itself on successful save.
struct NewCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    /// Local state for the new category's name.
    @State private var newCategoryName = ""

    /// Controls whether the categories list is shown expanded (vertical) or
    /// collapsed (horizontal scroller).
    @State private var categoriesExpanded: Bool = false

    /// The existing categories passed from the caller (used for context only).
    let categories: [Category]

    @Namespace var animation

    var body: some View {
        NavigationStack {
            List {
                if !categories.isEmpty {
                    Section(content: {
                        ExpandableCategoriesSection(expanded: categoriesExpanded,
                                                    expandable: categories.count > 1) {
                            ForEach(categories) {
                                CategoryButtonView(text: $0.name) { }
                            }
                        }
                    }, header: {
                        CategoriesSectionHeader(expanded: categoriesExpanded,
                                                expandable: categories.count > 1) {
                            withAnimation { categoriesExpanded.toggle() }
                        }
                    })
                }

                Section(.newCategorySectionTitle) {
                    EditCategorySectionView(newCategoryName: $newCategoryName) {
                        let newCategory = Category(name: newCategoryName)
                        modelContext.insert(newCategory)
                        dismiss()
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(.navigationBarTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    DismissButton()
                }
            }
        }
    }
}

// MARK: - Subviews

/// Header view for the categories section. Shows the section title and an
/// optional expand/collapse action.
private struct CategoriesSectionHeader: View {
    let expanded: Bool
    let expandable: Bool
    let action: () -> Void

    var body: some View {
        HStack {
            Text(.categoriesSectionTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            if expandable {
                let actionTitle: LocalizedStringKey = expanded ? .collapseHint : .expandHint
                Button(actionTitle, action: action)
            }
        }
    }
}

/// A container that switches between an expanded vertical layout and a
/// collapsed horizontal scroller for category buttons.
private struct ExpandableCategoriesSection<T: View>: View {
    let expanded: Bool
    let expandable: Bool
    let content: T

    init(expanded: Bool, expandable: Bool, @ViewBuilder content: () -> T) {
        self.expanded = expanded
        self.expandable = expandable
        self.content = content()
    }

    var body: some View {
        if expanded {
            ExpandedCategoriesSection(content: content)
        } else {
            CollapsedCategoriesSection(content: content)
        }
    }
}

/// Vertical layout used when the categories list is expanded.
///
/// This view simply stacks the provided content in a `VStack` aligned to
/// the leading edge. It is intentionally lightweight because the
/// `ExpandableCategoriesSection` decides when to display it.
private struct ExpandedCategoriesSection<T: View>: View {
    /// Vertical layout used when the categories list is expanded.
    ///
    /// This view simply stacks the provided content in a `VStack` aligned to
    /// the leading edge. It is intentionally lightweight because the
    /// `ExpandableCategoriesSection` decides when to display it.
    let content: T

    var body: some View {
        VStack(alignment: .leading) {
            content
        }
    }
}

/// A compact horizontal scroller used when the categories list is collapsed.
///
/// The view wraps the provided content in a horizontally scrolling `HStack`
/// and hides scroll indicators for a clean, compact appearance suitable for
/// the toolbar/preview context.
private struct CollapsedCategoriesSection<T: View>: View {
    let content: T

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                content
            }
        }
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
    }
}

/// A small form section that contains the text field and Save button for
/// creating a new category.
private struct EditCategorySectionView: View {
    @Binding var newCategoryName: String
    let saveAction: () -> Void

    var body: some View {
        TextField(.categoryNamePlaceholder, text: $newCategoryName)
            .textFieldStyle(.roundedBorder)
        Button(action: saveAction) {
            Text(.addNewCategoryButtonTitle)
                .frame(maxWidth: .infinity)
                .fontWeight(.semibold)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .listRowSeparator(.hidden)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let navigationBarTitle: Self = .init("Add Category")
    static let newCategorySectionTitle: Self = .init("New Category")
    static let categoriesSectionTitle: Self = .init("Categories")
    static let addNewCategoryButtonTitle: Self = .init("Add Category")
    static let categoryNamePlaceholder: Self = .init("New Category Name")
    static let collapseHint: Self = .init("Collapse")
    static let expandHint: Self = .init("Expand")
}

// MARK: - Preview

#if DEBUG
struct NewCategoryView_Previews: PreviewProvider {
    static let categories: [Category] = [
        .init(name: "First"),
        .init(name: "Second")
    ]

    static var previews: some View {
        Group {
            NewCategoryView(categories: [])
                .previewDisplayName("Without Categories")
            NewCategoryView(categories: categories)
                .previewDisplayName("With Categories")
        }
    }
}
#endif
