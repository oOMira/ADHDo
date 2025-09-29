//
//  TaskListView+Sheets.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 21.11.25.
//

import SwiftUI

// MARK: HyperFocusSheet

extension TaskListView {
    /// A view modifier that presents a HyperFocus session sheet for a given item.
    ///
    /// The modifier shows `HyperFocusView` when `isPresented` is true. The
    /// `remainingTime` binding is forwarded to the sheet so the owning
    /// `HyperFocusConfiguration` can drive the countdown. `onDisappear` is
    /// invoked whenever the sheet is dismissed.
    struct HyperFocusSheet: ViewModifier {
        let item: ToDoItem
        @Binding var isPresented: Bool
        @Binding var remainingTime: Double
        let onDisappear: () -> Void

        func body(content: Content) -> some View {
            content
                .sheet(isPresented: $isPresented) {
                    HyperFocusView(item: item, remainingTime: $remainingTime)
                        .presentationDetents([.medium])
                        .presentationBackground(.red.opacity(0.5))
                        .onDisappear(perform: onDisappear)
                }
        }
    }

}

// MARK: EditCategorySheet

extension TaskListView {
    /// A view modifier that presents the edit-categories screen as a sheet.
    ///
    /// `categories` is passed to the `EditCategoryView` so it can show the
    /// current set of categories. The `animationNamespace` is used to
    /// coordinate the navigation transition animation.
    struct EditCategorySheet: ViewModifier {
        @Binding var isPresented: Bool
        var animationNamespace: Namespace.ID
        let categories: [Category]

        func body(content: Content) -> some View {
            content
                .sheet(isPresented: $isPresented) {
                    EditCategoryView(categories: categories)
                        .interactiveDismissDisabled(true)
                        .presentationDetents([.large])
                        .navigationTransition(.zoom(sourceID: .transitionID.editCategory, in: animationNamespace))
                }
        }
    }
}

// MARK: AddCategorySheet

extension TaskListView {
    /// A view modifier that presents a sheet for creating a new category.
    ///
    /// The sheet shows `NewCategoryView`, which receives the current
    /// `categories` for context. The `animationNamespace` is forwarded for
    /// matched transition animations between the sheet and its source.
    struct AddCategorySheet: ViewModifier {
        @Binding var isPresented: Bool
        let categories: [Category]
        var animationNamespace: Namespace.ID

        func body(content: Content) -> some View {
            content
                .sheet(isPresented: $isPresented) {
                    NewCategoryView(categories: categories)
                        .interactiveDismissDisabled(true)
                        .presentationDetents([.large])
                        .navigationTransition(.zoom(sourceID: .transitionID.addCategory,
                                                    in: animationNamespace))
                }
        }
    }
}


// MARK: AddToDoItemSheet

extension TaskListView {
    /// A view modifier that presents the Add ToDo Item sheet.
    ///
    /// The sheet contains `AddToDoItemView` configured with the provided
    /// `categories` and participates in the matched navigation transition
    /// identified by `addItem`.
    struct AddToDoItemSheet: ViewModifier {
        @Binding var isPresented: Bool
        var animationNamespace: Namespace.ID
        let categories: [Category]

        func body(content: Content) -> some View {
            content
                .sheet(isPresented: $isPresented) {
                    AddToDoItemView(categories: categories)
                        .presentationDetents([.large])
                        .navigationTransition(.zoom(sourceID: .transitionID.addItem, in: animationNamespace))
                }
        }
    }
}
