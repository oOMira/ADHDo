//
//  ContentView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 20.09.25.
//

import SwiftUI

struct ContentView: View {
    @Namespace private var animationNamespace

    @State private var badgeNumber = Int.random(in: .badgeRange)
    @State private var searchText: String = .init()
    
    @State var currentItemVisible = false
    @State var noItemAlertVisible: Bool = false
    @State var currentItem: ToDoItem?
    
    var body: some View {
        TabView {
            // Task Lit Tab
            Tab(.listTabTitle, systemImage: .systemImage.listBullet.name) {
                TaskListView(focusItem: $currentItem)
            }
            .badge(badgeNumber)
            
            // About Tab
            Tab(.aboutTabTitle, systemImage: .systemImage.brain.name) {
                AboutSectionView()
            }
            
            // Settings Tab
            Tab(.settingsTabTitle, systemImage: .systemImage.gear.name) {
                SettingsView()
            }
            
            // Search Tab
            Tab(role: .search) {
                SearchSectionView(searchText: $searchText)
                    .searchable(text: $searchText)
            }
        }
        .tabViewBottomAccessory {
            ZStack {
                if currentItem != nil  {
                    FocusItemAccessoryView(currentItem: $currentItem)
                        .matchedTransitionSource(id: "tarnsitionID", in: animationNamespace)
                        .onTapGesture {
                            currentItemVisible.toggle()
                        }
                } else {
                    NoFocusItemAccessoryView()
                        .onTapGesture { noItemAlertVisible.toggle() }
                }
            }
        }

        .tabBarMinimizeBehavior(.onScrollDown)
        .repeatingTimer(every: .badgeTimerInterval, action: {
            badgeNumber = Int.random(in: .badgeRange)
        })
        .alert(.noTaskTitle, isPresented: $noItemAlertVisible) {
            Button(.okButtonTitle, role: .cancel) { }
        } message: {
            Text(.noTaskSelectedDescription)
        }
        .sheet(isPresented: $currentItemVisible) {
            FocusItemView(item: currentItem ?? .init(title: "title"))
                .presentationDetents([.medium])
                .navigationTransition(.zoom(sourceID: "tarnsitionID", in: animationNamespace))
                
                                      
        }
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let listTabTitle: Self = .init("List")
    static let aboutTabTitle: Self = .init("About")
    static let settingsTabTitle: Self = .init("Settings")
    static let noTaskTitle: Self = .init("You don't have a selected item")
    static let noTaskSelectedDescription: Self = .init("Swipe left on any item in the task list to focus!")
    static let okButtonTitle: Self = .init("OK")
}

private extension ClosedRange where Bound == Int {
    static let badgeRange = 1...99
}

private extension TimeInterval {
    static let badgeTimerInterval: Self = 5
}

// MARK: - Preview

#Preview {
    ContentView()
}
