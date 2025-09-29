//
//  TaskFilter.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 24.11.25.
//

import SwiftUI

enum TaskFilter: Identifiable, Equatable, Hashable {
    var id: String { title }
    
    case all
    case todo
    case done
    case favorites
    case custom(categoryName: String)
    
    var title: String {
        switch self {
        case .all: return "All"
        case .todo: return "ToDo"
        case .done: return "Done"
        case .favorites: return "Favorites"
        case .custom(let categoryName): return categoryName
        }
    }
    
    var configuration: SingleSelectButtonView.SelectionConfiguration {
        switch self {
        case .all: .init(title: title, image: .systemImage.tray.image, color: .red)
        case .todo: .init(title: title, image: .systemImage.listAndClipboard.image, color: .blue)
        case .done: .init(title: title, image: .systemImage.checkmarkCircle.image, color: .green)
        case .favorites: .init(title: title, image: .systemImage.star.image, color: .orange)
        case .custom: .init(title: title, image: .systemImage.tray.image, color: .gray)
        }
    }
    
    var predicate: Predicate<ToDoItem> {
        switch self {
        case .all: return #Predicate<ToDoItem> { _ in true }
        case .todo: return #Predicate<ToDoItem> { $0.done == false }
        case .done: return #Predicate<ToDoItem> { $0.done == true }
        case .favorites: return #Predicate<ToDoItem> { $0.favorite == true }
        case .custom(let categoryName): return #Predicate<ToDoItem> { $0.category?.name ?? "" == categoryName }
        }
    }
}

private extension String {
    static let allTitel: Self = .init("All")
    static let toDoTitle: Self = .init("ToDo")
    static let doneTitle: Self = .init("Done")
    static let favoritesTitle: Self = .init("Favorites")
}
