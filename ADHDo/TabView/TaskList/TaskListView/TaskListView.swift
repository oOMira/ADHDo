//
//  TaskListView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 25.10.25.
//

import SwiftUI
import SwiftData
import Combine

/// The main task list screen for the app.
///
/// `TaskListView` presents categories, the current feed (regular or MPH), and
/// provides controls for adding/editing tasks and categories. It owns the
/// `Feed` instance that builds the list content and coordinates sheet
/// presentation for add/edit/hyperfocus flows.
struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.name, order: .forward) private var categories: [Category]
    @State private var editMode: EditMode = .inactive
    @State private var isMPH: Bool = false
    @State private var currentSelection: TaskFilter = .todo
    @State private var path = NavigationPath()
    @StateObject private var feed = Feed(adProbability: 25,
                                         visibilityProbability: 75,
                                         fetchDescriptor: .init(predicate: TaskFilter.todo.predicate))

    @State var hyperfocusVisible = false
    @StateObject private var hyperFocusConfiguration = HyperFocusConfiguration()
    
    @Binding var focusItem: ToDoItem?

    @Namespace private var addItemNamespace
    @State var showAddPopupVisible = false

    @Namespace private var newCategoryNamespace
    @State var addCategoryVisible = false

    @Namespace private var menuNamespace
    @State var editCategoryVisible = false

    var body: some View {
        NavigationStack(path: $path) {
            List {
                // MARK: Category Section
                Section {
                    ScrollView(.horizontal) {
                        HStack {
                            var options: [TaskFilter] {
                                let defaultOptions = [TaskFilter.all, .todo, .done, .favorites]
                                let customOptions: [TaskFilter] = categories.map { .custom(categoryName: $0.name) }
                                return defaultOptions + customOptions
                            }
                            SingleSelectButtonView(options: options, selection: $currentSelection)
                                .accessibilityIdentifier(Accessibility.filterOptions)
                            NewCategoryButton(animationNamespace: newCategoryNamespace) {
                                addCategoryVisible.toggle()
                            }
                            .accessibilityLabel("Add new category button")
                            .accessibilityIdentifier(Accessibility.newCategoryButton)
                        }
                        .accessibilityElement(children: .combine)
                        .disabled(editMode.isEditing)
                    }
                    .categoryScrollViewStyle()
                }
                
                // MARK: Task List Section
                Section {
                    if feed.items.isEmpty {
                        EmptyHintCell()
                            .accessibilityIdentifier(Accessibility.emptyHint)
                    } else {
                        let createToDoItemCell: (ToDoItem) -> AnyView = { item in
                            AnyView(
                                ToDoItemCell(item: item,
                                             watchAction: { watch(item) },
                                             favoriteAction: { favorite(item) },
                                             deleteAction: { delete(item) },
                                             updateAction: { update(item) },
                                             tappedAction: { tapped(item) })
                                    .accessibilityIdentifier(Accessibility.taskRow(for: item.id.uuidString))
                            )
                        }

                        ForEach(isMPH ? feed.mph : feed.regular) { item in
                            switch item {
                            case .advert(let advert):
                                if editMode.isEditing {
                                    SponsoredItemPlaceHolderCell()
                                } else {
                                    SponsoredItemCell(adConfiguration: advert)
                                }
                            case .content(let item): createToDoItemCell(item)
                            case .invisibleContent(let item):
                                if editMode.isEditing {
                                    createToDoItemCell(item)
                                } else {
                                    SabotagingItem()
                                        .accessibilityElement(children: .combine)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .accessibilityIdentifier(Accessibility.taskList)
            // MARK: Toolbar
            .taskListToolbar(isTaskListEmpty: feed.items.isEmpty,
                             isMPH: $isMPH,
                             showEditCategories: editCategories,
                             enterHyperfocus: enterHyperfocus,
                             addNewItem: addNewItem,
                             addItemNamespace: addItemNamespace,
                             menuButtonNamespace: menuNamespace)
            // MARK: Navigation
            .editCategorySheet(isPresented: $editCategoryVisible,
                               animationNamespace: menuNamespace,
                               categories: categories)
            .addTodoItemSheet(isPresented: $showAddPopupVisible,
                              animationNamespace: addItemNamespace,
                              categories: categories)
            .hyperFocusSheet(item: feed.items.randomElement() ?? .init(title: "Title"),
                             isPresented: $hyperfocusVisible,
                             remainingTime: $hyperFocusConfiguration.remainingTime,
                             onDisappear: {
                guard hyperFocusConfiguration.hyperFocusOn else { return }
                hyperfocusVisible.toggle()
            })
            .addCategorySheet(isPresented: $addCategoryVisible,
                              categories: categories,
                              animationNamespace: newCategoryNamespace)
            .taskListStyle()
            // Update ToDoItem navigation
            .navigationDestination(for: ToDoItem.self) {
                UpdateToDoItemView(item: $0, categories: categories)
            }
            .navigationTitle(isMPH ? .barTitleMPH : .barTitle)
            .navigationSubtitle("\(currentSelection.title) - \(feed.items.count) items")
            .environment(\.editMode, $editMode)
        }
        // MARK: Lifecycle
        // shuffle timer
        .repeatingTimer(every: 30) {
            guard !isMPH, !editMode.isEditing else { return }
            withAnimation { feed.randomize() }
            UIAccessibility.post(notification: .announcement, argument: "Task list reshuffled")
        }
        // update feed
        .onChange(of: currentSelection) {
            withAnimation {
                feed.refresh(fetchDescriptor: .init(predicate: currentSelection.predicate))
            }
        }
    }
}

// MARK: - View+SheetHelper

// HyperfocusSheet
private extension View {
    func hyperFocusSheet(item: ToDoItem,
                         isPresented: Binding<Bool>,
                         remainingTime: Binding<Double>,
                         onDisappear: @escaping () -> Void) -> some View
    {
        modifier(
            TaskListView.HyperFocusSheet(item: item,
                                         isPresented: isPresented,
                                         remainingTime: remainingTime,
                                         onDisappear: onDisappear)
        )
    }
}

// EditCategorySheet
private extension View {
    func editCategorySheet(isPresented: Binding<Bool>,
                           animationNamespace: Namespace.ID,
                           categories: [Category]) -> some View
    {
        modifier(
            TaskListView.EditCategorySheet(isPresented: isPresented,
                                           animationNamespace: animationNamespace,
                                           categories: categories))
    }
}

// AddCategorySheet
private extension View {
    func addCategorySheet(isPresented: Binding<Bool>,
                          categories: [Category],
                          animationNamespace: Namespace.ID) -> some View
    {
        modifier(
            TaskListView.AddCategorySheet(isPresented: isPresented,
                                          categories: categories,
                                          animationNamespace: animationNamespace)
        )
    }
}

// AddToDoItemSheet
extension View {
    func addTodoItemSheet(isPresented: Binding<Bool>,
                          animationNamespace: Namespace.ID,
                          categories: [Category]) -> some View
    {
        modifier(
            TaskListView.AddToDoItemSheet(isPresented: isPresented,
                                          animationNamespace: animationNamespace,
                                          categories: categories)
        )
    }
}

// MARK: - UI

// MARK: UI Elements

private struct NewCategoryButton: View {
    let animationNamespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(.newCategoryButtonTitle, action: action)
            .font(.title3)
            .buttonStyle(.bordered)
            .matchedTransitionSource(id: .transitionID.addCategory, in: animationNamespace)
    }
}

private extension View {
    func taskListStyle() -> some View {
        self
            .scrollClipDisabled(true)
            .listStyle(.plain)
    }
}

private extension View {
    func taskListToolbar(isTaskListEmpty: Bool,
                         isMPH: Binding<Bool>,
                         showEditCategories: @escaping () -> Void,
                         enterHyperfocus: @escaping () -> Void,
                         addNewItem: @escaping () -> Void,
                         addItemNamespace: Namespace.ID,
                         menuButtonNamespace: Namespace.ID) -> some View {
        modifier(TaskListView.TaskListToolbar(isTaskListEmpty: isTaskListEmpty,
                                              isMPH: isMPH,
                                              showEditCategories: showEditCategories,
                                              enterHyperfocus: enterHyperfocus,
                                              addNewItem: addNewItem,
                                              addItemNamespace: addItemNamespace,
                                              menuButtonNamespace: menuButtonNamespace))
    }
}

// MARK: Styling

private extension ScrollView {
    func categoryScrollViewStyle() -> some View {
        self
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            .listRowSeparator(.hidden, edges: .top)
            .listRowInsets(.top, .spacing.extraSmall.cgFloat)
    }
}

// MARK: - Helper

private extension TaskListView {
    /// Delete items at the given index offsets from the current feed.
    ///
    /// The function resolves the current feed (MPH vs regular), looks up the
    /// associated `ToDoItem` for each feed element, and deletes it from the
    /// model context.
    func deleteItems(offsets: IndexSet) {
        let currentFeed = isMPH ? feed.mph : feed.regular
        offsets.forEach { index in
            guard let item = currentFeed[index].item else { return }
            delete(item)
        }
    }
    
    /// Start a hyperfocus session by configuring the timer and toggling the sheet.
    private func enterHyperfocus() {
        hyperFocusConfiguration.startTimer(remainingTime: .hyperfocusTime)
        hyperfocusVisible.toggle()
    }
    
    /// Toggle visibility of the edit categories sheet.
    private func editCategories() {
        editCategoryVisible.toggle()
    }
    
    /// Show/hide the add-new-item sheet.
    private func addNewItem() {
        showAddPopupVisible.toggle()
    }
    
    /// Set the given item as the currently focused item (for the watch flow).
    private func watch(_ item: ToDoItem) {
        focusItem = item
    }
    
    /// Toggle favorite state on the provided item and persist the change.
    private func favorite(_ item: ToDoItem) {
        item.favorite.toggle()
        try? modelContext.save()
    }
    
    /// Delete the provided item from the model context.
    private func delete(_ item: ToDoItem) {
        withAnimation {
            modelContext.delete(item)
            if focusItem == item { focusItem = nil }
            try? modelContext.save()
            editMode = .inactive
        }
    }
    
    /// Navigate to the update view for the provided item.
    private func update(_ item: ToDoItem) {
        path.append(item)
    }
    
    /// Toggle the done flag for the provided item and persist the change.
    private func tapped(_ item: ToDoItem) {
        withAnimation {
            item.done.toggle()
            try? modelContext.save()
        }
    }
}

// MARK: - Accessibility

private enum Accessibility {
    static let taskList = "taskList_list"
    static let filterOptions = "taskList_filterOptions"
    static let newCategoryButton = "taskList_newCategoryButton"
    static let emptyHint = "taskList_emptyHint"
    static func taskRow(for id: String) -> String { "taskList_row_\(id)" }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let newCategoryButtonTitle: Self = .init("New category")
    static let watchActionTitle: Self = .init("Watch")
    static let updateActionTitle: Self = .init("Update")
    static let favoriteActionTitle: Self = .init("Favorite")
    static let markAsOpenMenuItemTitle: Self = .init("Mark all as open")
    static let markAsDoneMenuItemTitle: Self = .init("Mark all as done")
    static let hyperfocusMenuItemTitle: Self = .init("Hyperfocus!!1!!!")
    static let editCategoriesMenuItemTitle: Self = .init("Edit Categories")
    static let enterMPHModeMenuItemTitle: Self = .init("Enter MPH Mode")
    static let exitMPHModeMenuItemTitle: Self = .init("Exit MPH Mode")
    static let barTitle: Self = .init("ADHDo")
    static let barTitleMPH: Self = .init("ADHDo (MPH)")
    static let cryingEmoji: Self = .init("😭")
}

private extension Double {
    static let hyperfocusTime: Self = 10
}

// MARK: - Preview

#if DEBUG
struct TaskList_Previews: PreviewProvider {
    @Namespace private static var hyperfocusNamespace
    
    static var previews: some View {
        TaskListView(focusItem: .constant(
            .init(title: "Title")
        ))
        .modelContainer(for: ToDoItem.self, inMemory: true)
    }
}
#endif
