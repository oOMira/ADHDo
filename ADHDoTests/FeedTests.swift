import Foundation
import Testing
import SwiftData
@testable import ADHDo

@MainActor final class FeedTests {
    let items: [ToDoItem] = (1...1000).map { .init(title: "Item \($0)", done: true) }
    let repetitions = 25
    let adProbaility = 30
    let visibilityProbability = 80
    
    @Test func testBuildMPHFeedContainsOnlyContent() {
        let mph = Feed.buildMPHFeed(for: items)

        #expect(mph.count == items.count)
        #expect(mph.allSatisfy { $0.isContent })
    }

    // Only test probabilities, try again if it fails
    @Test func testProbaility() {
        let distribution = (0..<repetitions)
            .map { _ in buildMockRegularFeed() }
            .reduce(into: (adverts: 0, content: 0, invisibleContent: 0)) { acc, feed in
                acc.adverts += feed.filter { $0.isAdvert }.count
                acc.content += feed.filter { $0.isContent }.count
                acc.invisibleContent += feed.filter { $0.isInvisible }.count
            }

        let expectedAds = Double(items.count) * (Double(adProbaility) / 100.0)
        let advertsPerFeed = Double(distribution.adverts) / Double(repetitions)
        let advertsRange = getRange(for: expectedAds, margin: 0.1)
        #expect(advertsRange.contains(advertsPerFeed))
        
        let expectedContentItems = Double(items.count) * (Double(visibilityProbability) / 100.0)
        let contentPerFeed = Double(distribution.content) / Double(repetitions)
        let contentRange = getRange(for: expectedContentItems, margin: 0.1)
        #expect(contentRange.contains(contentPerFeed))
        
        let expectedInvisibleItems = Double(items.count) * (1.0 - Double(visibilityProbability) / 100.0)
        let invisibleItemsPerFeed = Double(distribution.invisibleContent) / Double(repetitions)
        let invisibleRange = getRange(for: expectedInvisibleItems, margin: 0.1)
        #expect(invisibleRange.contains(invisibleItemsPerFeed))
    }
    
    @Test func testAdFree() {
        let feed = Feed.buildRegularFeed(for: items,
                                         adProbability: 0,
                                         visibilityProbability: visibilityProbability,
                                         shuffle: true)

        let numberOfAds = feed.filter { $0.isAdvert }.count
        #expect(numberOfAds == 0)
    }
    
    @Test func testAllVisible() {
        let feed = Feed.buildRegularFeed(for: items,
                                         adProbability: 0,
                                         visibilityProbability: 100,
                                         shuffle: true)

        let numberOfAds = feed.filter { $0.isInvisible }.count
        #expect(numberOfAds == 0)
    }

    @Test func testRandomize() throws {
        let container = try ModelContainer(for: ToDoItem.self,
                                           configurations: .init(isStoredInMemoryOnly: true))
        items.forEach { container.mainContext.insert($0) }
        try container.mainContext.save()
        let feed = Feed(context: container.mainContext,
                    adProbability: adProbaility,
                    visibilityProbability: visibilityProbability,
                    shuffle: true)
        let oldFeed: (regular: [FeedElement], mph: [FeedElement]) = (feed.regular, feed.mph)
        feed.randomize()

        let isRegularDifferent = zip(oldFeed.regular, feed.regular).contains { $0 != $1 }
        #expect(isRegularDifferent)
        
        let isMPHDifferent = zip(oldFeed.mph, feed.mph).contains { $0 != $1 }
        #expect(isMPHDifferent == false)
    }
    
    @Test func testOutOfBounds_upper() throws {
        let feed = Feed.buildRegularFeed(for: items,
                                         adProbability: 110,
                                         visibilityProbability: 110,
                                         shuffle: true)
        // Item afert each content
        #expect(feed.count == items.count * 2)
        
        let containsInvisible = feed.contains { $0.isInvisible }
        #expect(containsInvisible == false)
    }
    
    @Test func testOutOfBounds_lower() throws {
        let feed = Feed.buildRegularFeed(for: items,
                                         adProbability: -10,
                                         visibilityProbability: -10,
                                         shuffle: true)
        // Item afert each content
        #expect(feed.count == items.count)
        
        let containsVisible = feed.contains { $0.isContent }
        #expect(containsVisible == false)
        
        let containsAdverts = feed.contains { $0.isAdvert }
        #expect(containsAdverts == false)
    }
    
    // Only test probabilities, try again if it fails
    @Test func testNotHidingOpenItems() {
        let openItmes = (1...1000).map { ToDoItem(title: "Item \($0)", done: false) }
        let feed = Feed.buildRegularFeed(for: openItmes,
                                         adProbability: .zero,
                                         visibilityProbability: .zero,
                                         shuffle: true)
        let containsInvisible = feed.contains { $0.isInvisible }
        #expect(containsInvisible == false)
    }
}

// MARK: - FeedTests+Helpers

private extension FeedTests {
    private func buildMockRegularFeed() -> [FeedElement] {
        Feed.buildRegularFeed(for: items,
                              adProbability: adProbaility,
                              visibilityProbability: visibilityProbability,
                              shuffle: true)
    }
    
    private func getRange(for value: Double, margin: Double) -> ClosedRange<Double> {
        let lower = Double(value) * (1 - margin)
        let upper = Double(value) * (1 + margin)
        return lower...upper
    }
}
