//
//  ADHDoApp.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 20.09.25.
//

import SwiftUI
import SwiftData

@main
struct ADHDoApp: App {
    static var sharedModelContext: ModelContext = {
        let schema = Schema([
            ToDoItem.self,
            Category.self,
            Bookmark.self
        ])
        
        do {
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            let context = ModelContext(container)
            context.autosaveEnabled = false
            return context
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContext(Self.sharedModelContext)
    }
}
