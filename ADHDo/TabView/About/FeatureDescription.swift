//
//  FeatureDescription.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 31.10.25.
//

import SwiftUI

// TODO: Fill content
/// Represents the different features available within the app,
/// providing access to  names, descriptions, and associated images.
enum FeatureDescription: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    /// The hyperfocus feature, designed to enhance concentration.
    case hyperfocus
    
    /// The to-do feature, for managing tasks to be completed.
    case toDo
    
    /// The done feature, representing completed tasks.
    case done
    
    /// The focus item feature, highlighting important tasks.
    case focusItem
    
    /// The search suggestions feature, offering suggested search terms.
    case searchSuggestions
    
    /// The search feature, allowing users to search through content.
    case search
    
    /// Returns a configuration containing the title, description, and optional image
    /// associated with the current feature case.
    var configuration: Configuration {
        switch self {
        case .hyperfocus: return .init(title: .hyperfocusTitle, description: .hyperfocusDescription, image: .hyperfocus)
        case .toDo: return .init(title: .toDoTitle, description: .toDoDescription)
        case .done: return .init(title: .doneTitle, description: .doneDescription)
        case .focusItem: return .init(title: .focusItemTitle, description: .focusItemDescription)
        case .searchSuggestions: return .init(title: .searchSuggestionsTitle, description: .searchSuggestionsDescription)
        case .search: return .init(title: .searchTitle, description: .searchDescription)
        }
    }
}

// MARK: - FeatureDescription+ContentConfiguration

extension FeatureDescription {
    /// Configuration struct containing localized text and an optional image
    /// that describe a feature.
    struct Configuration {
        /// The localized title text describing a feature.
        let title: Text
        
        /// The localized description text providing more detail about the feature.
        let description: Text
        
        /// An optional image representing the feature visually.
        let image: Image?
        
        /// Initializes the configuration with given title and description strings,
        /// and an optional image.
        /// - Parameters:
        ///   - title: A string representing the feature's title.
        ///   - description: A string representing the feature's description.
        ///   - image: An optional image representing the feature.
        init(title: String, description: String, image: Image? = nil) {
            self.title = .init(title)
            self.description = .init(description)
            self.image = image
        }
    }
}

// MARK: - Constants

// String

private extension String {
    static let hyperfocusTitle = "Hyperfocus"
    static let toDoTitle = "ToDo"
    static let doneTitle = "Done"
    static let focusItemTitle = "Focus Item"
    static let searchSuggestionsTitle = "Search Suggestions"
    static let searchTitle = "Search"
    
    static let hyperfocusDescription = loremIpsum
    static let toDoDescription = loremIpsum
    static let doneDescription = loremIpsum
    static let focusItemDescription = loremIpsum
    static let searchSuggestionsDescription = loremIpsum
    static let searchDescription = loremIpsum
    
    // TODO: remove
    private static let loremIpsum = """
                    Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.
                    """
}

// Images

private extension Image {
    static let hyperfocus: Image = .init("Hyperfocus")
}
