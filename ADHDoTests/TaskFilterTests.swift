//
//  TaskFilterTests.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 28.11.25.
//

import Foundation
import Testing
import SwiftData
@testable import ADHDo


@MainActor final class TaskFilterTests {
    static let testCategoryName = "Test Category"
    let doneItems: [ToDoItem] = (1...5).map { .init(title: "Item \($0)", done: true) }
    let openItems: [ToDoItem] = (1...10).map { .init(title: "Item \($0)", done: false) }
    let cateogryItems: [ToDoItem] = (1...15).map {
        .init(title: "Item \($0)", category: .init(name: testCategoryName), done: false)
    }
    var mockData: [ToDoItem] { doneItems + openItems + cateogryItems }
    
    func getMockModelContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ToDoItem.self, Category.self, configurations: config)
        container.mainContext.insert(Category(name: Self.testCategoryName))
        mockData.forEach { container.mainContext.insert($0) }
        return container
    }

    @Test func testAllFilter() throws {
        let container = try getMockModelContainer()
        let fetchedItems = try container.mainContext.fetch(.init(predicate: TaskFilter.all.predicate))
        
        let fetchDistribution = fetchedItems.getItemDistribution(category: Self.testCategoryName)
        let mockDistribution = mockData.getItemDistribution(category: Self.testCategoryName)

        #expect(fetchedItems.count == mockData.count)
        #expect(fetchDistribution == mockDistribution)
    }

    @Test func testDoneFilter() throws {
        let container = try getMockModelContainer()
        let fetchedItems = try container.mainContext.fetch(.init(predicate: TaskFilter.done.predicate))
        
        let fetchDistribution = fetchedItems.getItemDistribution(category: Self.testCategoryName)
        let mockDistribution = mockData.getItemDistribution(category: Self.testCategoryName)
        
        #expect(fetchDistribution.done == mockDistribution.done)
        #expect(fetchDistribution.open == 0)
    }

    @Test func testToDoFilter() throws {
        let container = try getMockModelContainer()
        let fetchedItems = try container.mainContext.fetch(.init(predicate: TaskFilter.todo.predicate))
        
        let fetchDistribution = fetchedItems.getItemDistribution(category: Self.testCategoryName)
        let mockDistribution = mockData.getItemDistribution(category: Self.testCategoryName)
        
        #expect(fetchDistribution.open == mockDistribution.open)
        #expect(fetchDistribution.done == 0)
    }

    @Test func testCateogryFilter() throws {
        let container = try getMockModelContainer()
        container.mainContext.insert(Category(name: "other category"))
        let fetchedItems = try container.mainContext.fetch(.init(predicate: TaskFilter.custom(name: Self.testCategoryName).predicate))
        
        let fetchDistribution = fetchedItems.getItemDistribution(category: Self.testCategoryName)
        let mockDistribution = mockData.getItemDistribution(category: Self.testCategoryName)
        
        #expect(fetchDistribution.category == mockDistribution.category)
        
        let containsDifferentCateogry = fetchedItems.contains { $0.category?.name != Self.testCategoryName }
        #expect(containsDifferentCateogry == false)
    }
}

// MARK: - Helper

private extension Array where Element == ToDoItem {
    func getItemDistribution(category categoryName: String) -> (done: Int, open: Int, category: Int) {
        reduce(into: (done: 0, open: 0, category: 0)) { acc, item in
            if item.done { acc.done += 1 }
            if !item.done { acc.open += 1 }
            if item.category?.name == categoryName { acc.category += 1 }
        }
    }
}
