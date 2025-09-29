//
//  DataModelTest.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 30.11.25.
//

@testable import ADHDo
import Testing
import SwiftData

@MainActor final class DataModelTest {
    static let testCategoryName = "Test Category"

    @Test func testDefault() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ToDoItem.self, Category.self, configurations: config)
        let category = Category(name: Self.testCategoryName)
        container.mainContext.insert(category)
        let item = ToDoItem(title: "Test Item", category: category)
        container.mainContext.insert(item)
        try container.mainContext.save()
        let fetchedItems = try container.mainContext.fetch(.init(predicate: TaskFilter.all.predicate))
        
        #expect(fetchedItems.first?.category != nil)
        #expect(fetchedItems.first?.category?.name == category.name)
        container.mainContext.delete(category)
        try container.mainContext.save()
        #expect(fetchedItems.first?.category == nil)
    }
}
