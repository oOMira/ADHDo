//
//  Feed.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 17.11.25.
//

import Combine
import CoreData
import SwiftData
import SwiftUI

/// A view-model style wrapper that builds and exposes a UI "feed" from a collection
/// of `ToDoItem` model objects.
///
/// Feed is responsible for constructing two representations used by the UI:
/// - `regular`: the feed used for the main list (may include adverts / invisibles)
/// - `mph`: a simplified feed with only content elements
///
/// The class is `@MainActor`-isolated and publishes changes via `@Published` so
/// it can be observed directly from SwiftUI views or other main-actor consumers.
@MainActor
final class Feed: ObservableObject {
    var context: ModelContext = ADHDoApp.sharedModelContext
    /// The source items backing the feed. These are SwiftData model objects
    /// that were used to construct the feed elements.
    @Published private(set) var items: [ToDoItem]
    
    /// The primary feed used for the UI. This may contain `advert` elements and
    /// invisible placeholders depending on visibility/ad probabilities.
    @Published private(set) var regular: [FeedElement]
    
    /// Contains only content elements.
    @Published private(set) var mph: [FeedElement]
    
    private let adProbability: Int
    private let visibilityProbability: Int
    private let shouldShuffle: Bool
    private var fetchDescriptor: FetchDescriptor<ToDoItem>
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Create a `Feed` by fetching items from the shared model container's
    /// main context using the provided `fetchDescriptor`.
    ///
    /// - Parameters:
    ///   - context: the context to fetch from
    ///   - adProbability: percent chance (0...100) to insert an advert next to an item
    ///   - visibilityProbability: percent chance (0...100) that a completed item remains visible
    ///   - shuffle: whether the feed should be shuffled when built
    ///   - fetchDescriptor: the SwiftData fetch descriptor used to load `ToDoItem` objects
    ///
    ///   This method refreshes on modelcontext saves to keep the feed up to date.
    init(context: ModelContext? = nil,
         adProbability: Int,
         visibilityProbability: Int,
         shuffle: Bool = true,
         fetchDescriptor: FetchDescriptor<ToDoItem> = .init())
    {
        self.context = context ?? ADHDoApp.sharedModelContext
        self.adProbability = adProbability
        self.visibilityProbability = visibilityProbability
        self.shouldShuffle = shuffle
        self.fetchDescriptor = fetchDescriptor
        
        let items = (try? self.context.fetch(fetchDescriptor)) ?? []
        self.mph = Self.buildMPHFeed(for: items)
        self.regular = Self.buildRegularFeed(for: items,
                                             adProbability: adProbability,
                                             visibilityProbability: visibilityProbability,
                                             shuffle: shuffle)
        self.items = items
        observeModelContext()
    }
}

// MARK: - Model Context Observation

extension Feed {
    /// Start observing model-context and persistent-store notifications.
    ///
    /// This method subscribes to two notifications:
    /// 1. `ModelContext.didSave` — emitted when the app's `ModelContext` saves its changes.
    /// 2. `NSPersistentStoreRemoteChange` — emitted when the persistent store reports
    ///    an external/remote change (for example, a CloudKit sync or background import).
    ///
    /// Both subscriptions deliver events on the main queue and call `refresh(...)` so the
    /// feed is recomputed on the main actor. Subscriptions are stored in `cancellables`
    /// and automatically cancelled when the `Feed` instance is deallocated.
    func observeModelContext() {
        // Subscribe to local ModelContext saves. Keep the feed updated when the app
        // saves changes to the main/foreground model context.
        NotificationCenter.default
            .publisher(for: ModelContext.didSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.refresh(fetchDescriptor: self.fetchDescriptor)
            }
            .store(in: &cancellables)
        
        // Subscribe to remote persistent-store changes (external syncs/CloudKit).
        // Deliver on the main queue so UI-observed published properties are updated
        // on the main actor.
        NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.refresh(fetchDescriptor: self.fetchDescriptor)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Lifecycle

extension Feed {
    /// Refresh the feed by fetching `ToDoItem` objects from the provided `fetchDescriptor`
    /// This updates `items`, `mph` and `regular`.
    ///
    /// This method is safe to call from the main actor (the class is @MainActor).
    func refresh(fetchDescriptor: FetchDescriptor<ToDoItem>) {
        self.fetchDescriptor = fetchDescriptor
        refresh()
    }

    /// Refresh the feed by fetching `ToDoItem` objects from the stored `fetchDescriptor`
    /// This updates `items`, `mph` and `regular`.
    ///
    /// This method is safe to call from the main actor (the class is @MainActor).
    func refresh() {
        withAnimation {
            self.items = (try? context.fetch(fetchDescriptor)) ?? []
            self.mph = Self.buildMPHFeed(for: items)
            self.regular = Self.buildRegularFeed(for: items,
                                                 adProbability: adProbability,
                                                 visibilityProbability: visibilityProbability,
                                                 shuffle: shouldShuffle)
        }
    }
}

// MARK: - Randomization

extension Feed {
    /// Rebuild the `regular` feed using the current `items` and shuffle flag.
    /// This method triggers a new computation of the feed sequence and assigns
    /// it to the `regular` published property.
    func randomize() {
        regular = Self.buildRegularFeed(for: items,
                                        adProbability: adProbability,
                                        visibilityProbability: visibilityProbability,
                                        shuffle: shouldShuffle)
    }
    
}

// MARK: - Feed Builder

extension Feed {
    /// Build the regular feed representation from a list of items.
    ///
    /// - Parameters:
    ///   - items: source items
    ///   - adProbability: percent chance (0...100) to insert an advert next to an item
    ///   - visibilityProbability: percent chance (0...100) that a completed item remains visible
    ///   - shuffle: whether the resulting feed should be shuffled
    /// - Returns: an array of `FeedElement` values representing the feed.
    static func buildRegularFeed(for items: [ToDoItem],
                                 adProbability: Int,
                                 visibilityProbability: Int,
                                 shuffle: Bool) -> [FeedElement] {
        let feed = items.flatMap { item in
            let adVisible = Int.random(in: 0...100) < adProbability
            let itemVisible = !item.done || Int.random(in: 0...100) <= visibilityProbability
            let itemElement: FeedElement = itemVisible ? .content(item) : .invisibleContent(item)
            
            let adElement: FeedElement?
            if let advert = advertList.randomElement(), adVisible {
                adElement = .advert(advert)
            } else {
                adElement = nil
            }
            return [itemElement, adElement].compactMap { $0 }
        }
        return shuffle ? feed.shuffled() : feed
    }
    
    /// Build the MPH feed (content-only) from a list of items.
    static func buildMPHFeed(for items: [ToDoItem]) -> [FeedElement] {
        items.map { .content($0) }
    }
}
