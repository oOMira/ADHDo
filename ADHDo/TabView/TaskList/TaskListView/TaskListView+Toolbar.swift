//
//  TaskListView+Toolbar.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 21.11.25.
//

import SwiftUI

extension TaskListView {
    /// A toolbar modifier for the `TaskListView` that provides the top-bar
    /// controls (more menu, edit button and add button).
    ///
    /// - Parameters:
    ///   - isTaskListEmpty: whether the underlying task list is empty (affects
    ///     which actions are shown).
    ///   - isMPH: binding that toggles MPH mode.
    ///   - showEditCategories: callback to present the Edit Categories sheet.
    ///   - enterHyperfocus: callback to start a hyperfocus session.
    ///   - addNewItem: callback to present the Add Item sheet.
    ///   - addItemNamespace / menuButtonNamespace: animation namespaces used
    ///     for matched transition effects when presenting sheets.
    struct TaskListToolbar: ViewModifier {
        let isTaskListEmpty: Bool
        @Binding var isMPH: Bool
        let showEditCategories: () -> Void
        let enterHyperfocus: () -> Void
        let addNewItem: () -> Void
        let addItemNamespace: Namespace.ID
        let menuButtonNamespace: Namespace.ID
        
        func body(content: Content) -> some View {
            content.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    MoreMenu(isTaskListEmpty: isTaskListEmpty,
                             isMPH: $isMPH,
                             showEditCategories: showEditCategories,
                             enterHyperfocus: enterHyperfocus,
                             animationNamespace: menuButtonNamespace)
                }
                if !isTaskListEmpty {
                    ToolbarItem { EditButton() }
                }
                ToolbarItem {
                    Button("Add", systemImage: .systemImage.plus.name, action: addNewItem)
                }
                .matchedTransitionSource(id: .transitionID.addItem, in: addItemNamespace)
            }
        }
    }
}

extension TaskListView.TaskListToolbar {
    /// The "more" menu shown in the toolbar. It provides quick actions such as
    /// toggling MPH mode, opening the edit-categories sheet, or starting
    /// a hyperfocus session.
    struct MoreMenu: View {
        let isTaskListEmpty: Bool
        @Binding var isMPH: Bool
        let showEditCategories: () -> Void
        let enterHyperfocus: () -> Void
        let animationNamespace: Namespace.ID
        
        var body: some View {
            Menu {
                Button(.editCategoriesMenuItemTitle, action: showEditCategories)
                Button(isMPH ? .exitMPHModeMenuItemTitle : .enterMPHModeMenuItemTitle) {
                    withAnimation { isMPH.toggle() }
                }
                if !isTaskListEmpty {
                    Button(.hyperfocusMenuItemTitle, action: enterHyperfocus)
                        .accessibilityLabel(.hyperfocusAccessibilityLabel)
                }
            } label: {
                Image(systemName: .systemImage.ellipsis.name)
            }
            .matchedTransitionSource(id: .transitionID.editCategory, in: animationNamespace)
        }
    }
}

// MARK: - Constatns

private extension LocalizedStringKey {
    static let newCategoryButtonTitle: Self = .init("New category")
    static let watchActionTitle: Self = .init("Watch")
    static let updateActionTitle: Self = .init("Update")
    static let favoriteActionTitle: Self = .init("Favorite")
    static let markAsOpenMenuItemTitle: Self = .init("Mark all as open")
    static let markAsDoneMenuItemTitle: Self = .init("Mark all as done")
    static let hyperfocusMenuItemTitle: Self = .init("Hyperfocus!!1!!!")
    static let hyperfocusAccessibilityLabel: Self = .init("Hyperfocus !!!")
    static let editCategoriesMenuItemTitle: Self = .init("Edit Categories")
    static let enterMPHModeMenuItemTitle: Self = .init("Enter MPH Mode")
    static let exitMPHModeMenuItemTitle: Self = .init("Exit MPH Mode")
    static let barTitle: Self = .init("ADHDo")
    static let barTitleMPH: Self = .init("ADHDo (MPH)")
}

enum TransitionID {
    case addCategory
    case addItem
    case editCategory
}

extension Hashable {
    typealias transitionID = TransitionID
}

// MARK: - Preview

#if DEBUG
private struct TaskListToolbarPreviewContainer: View {
    @State private var isMPH = false
    @Namespace private var animationNamespace

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Toolbar Preview Content")
                    .padding()
                Text("MPH: \(isMPH ? "On" : "Off")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(TaskListView.TaskListToolbar(
                isTaskListEmpty: false,
                isMPH: $isMPH,
                showEditCategories: {},
                enterHyperfocus: {},
                addNewItem: {},
                addItemNamespace: animationNamespace,
                menuButtonNamespace: animationNamespace
            ))
        }
    }
}

struct TaskListToolbar_Previews: PreviewProvider {
    static var previews: some View {
        TaskListToolbarPreviewContainer()
            .previewLayout(.sizeThatFits)
    }
}
#endif
