//
//  SearchView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 08.10.25.
//

import SwiftUI
import SwiftData

/// Presents suggestion tiles and the user's saved bookmarks for quick access.
///
/// This view shows curated suggestion cards followed by the user's bookmarks
/// stored in SwiftData. It exposes an add button in the toolbar to create a new
/// bookmark and a sheet to present the add-bookmark flow.
struct SearchSuggestionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var bookmarks: [Bookmark]

    @State private var isPresentingAddNewCategory = false

    @Namespace private var animationNamespace
    let addItemTransitionID = "addItemTransition"

    var body: some View {
            List {
                if bookmarks.isEmpty {
                    Section {
                        NoBookmarksHintView()
                            .accessibilityIdentifier(Accessibility.noBookmarksHint)
                    }
                } else {
                    Section {
                        ForEach(SearchSuggestionsConfiguration.defaultConfig) {
                            SearchSuggestionNavigationLink(configuration: $0)
                        }
                        .listRowInsets(.vertical, .spacing.small.cgFloat)
                    }
                    .accessibilityIdentifier(Accessibility.suggestionsSection)
                    
                    // Bookmarks
                    Section {
                        ForEach(bookmarks) { bookmark in
                            BookmarkCell(bookmark: bookmark, deleteAction: {
                                withAnimation {
                                    modelContext.delete(bookmark)
                                }
                            })
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(.vertical, .spacing.small.cgFloat)
                    }
                    .accessibilityIdentifier(Accessibility.bookmarksSection)
                }
            }
            .accessibilityIdentifier(Accessibility.list)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        isPresentingAddNewCategory.toggle()
                    }, label: {
                        Image(systemName: .systemImage.plus.name)
                    })
                    .accessibilityIdentifier(Accessibility.addButton)
                })
                .matchedTransitionSource(id: addItemTransitionID, in: animationNamespace)
            }
            .listStyle(.plain)
            .scrollClipDisabled(true)
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationTitle(.searchTitle)
            .sheet(isPresented: $isPresentingAddNewCategory) {
                AddNewBookmarkView()
                    .interactiveDismissDisabled(true)
                    .presentationDetents([.large])
                    .navigationTransition(.zoom(sourceID: addItemTransitionID, in: animationNamespace))
                    .accessibilityIdentifier(Accessibility.addBookmarkSheet)
            }
        }
}

// MARK: View Helper

// SearchSuggestionNavigationLink
extension SearchSuggestionsView {
    struct SearchSuggestionNavigationLink: View {
        let configuration: SearchSuggestionsConfiguration
        @Namespace var animationNamespace

        var body: some View {
            NavigationLink {
                SearchSuggestionDetailsView(configuration: configuration)
                    .navigationTransition(.zoom(sourceID: configuration,
                                                in: animationNamespace))
            } label: {
                SearchSuggestionCell(configuration: configuration, action: {})
                    .matchedTransitionSource(id: configuration,
                                             in: animationNamespace)
                    .listRowSeparator(.hidden)
                    .accessibilityHint("Advert")
            }
            .accessibilityElement(children: .combine)
            .navigationLinkIndicatorVisibility(.hidden)
            .listRowSeparator(.hidden)
        }
    }
}

// MARK: Constants

private extension LocalizedStringKey {
    static let searchTitle: Self = .init("Search")
}

// MARK: - Accessibility

private enum Accessibility {
    static let list = "searchSuggestions_list"
    static let suggestionsSection = "searchSuggestions_suggestionsSection"
    static let bookmarksSection = "searchSuggestions_bookmarksSection"
    static let addButton = "searchSuggestions_addButton"
    static let addBookmarkSheet = "searchSuggestions_addBookmarkSheet"
    static let noBookmarksHint = "searchSuggestions_noBookmarksHint"
}

// MARK: Preview

// TODO: add data for preview
#if DEBUG
struct SearchSuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSuggestionsView()
    }
}
#endif
