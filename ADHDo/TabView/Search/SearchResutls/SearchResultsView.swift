//
//  SearchResultsView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 23.10.25.
//

import SwiftUI

/// A view that presents search-related controls and a list of search results.
///
/// Shows a category picker and a set of example search results. The view
/// is intended to be embedded in the Search tab and receives the current search
/// query via a two-way binding.
struct SearchResultsView: View {
    /// The currently selected search category.
    @State private var searchCategory: SearchCategorie = .all

    /// Binding to the search text entered by the user.
    @Binding var searchText: String

    /// Backing store for the search results currently loaded from a local JSON resource.
    ///
    /// This state property is lazily initialized from the bundled file named
    /// `Conspiracies.json`. It returns `nil` when the resource cannot be found
    /// or if decoding fails;
    @State private(set) var searchResultData: [SearchResult]? = {
        guard let url = Bundle.main.url(forResource: .resourceName,
                                        withExtension: .resourceFromat) else { return nil }
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: url)
            var list = try decoder.decode([SearchResult].self, from: data)
            list.shuffle()
            return list
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    /// The list of search results filtered by the current `searchText`.
    ///
    /// - Behavior:
    ///   - If `searchResultData` is `nil` an empty array is returned.
    ///   - If `searchText` is empty the full (shuffled) result list is returned.
    ///   - Otherwise a case-insensitive filter is applied against each result's
    ///     `name` and `description` fields.
    var filteredSearchResultData: [SearchResult] {
        guard let searchResultData else { return [] }
        guard !searchText.isEmpty else { return searchResultData }
        return searchResultData.filter { item in
            [item.name, item.description]
                .map { $0.lowercased() }
                .contains { $0.contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        List {
            CustomPicker(title: .searchCategoryPickerTitle, selectionOptions: SearchCategorie.allCases, selection: $searchCategory)
                .listRowSeparator(.hidden)
                .controlSize(.large)
                .pickerStyle(.palette)
                .padding(.horizontal, .spacing.extraSmall.cgFloat)

            ForEach(filteredSearchResultData) {
                SearchResultView(searchResult: $0)
            }
        }
        .onChange(of: searchCategory) {
            withAnimation {
                searchResultData?.shuffle()
            }
        }
        .scrollClipDisabled(true)
        .scrollDismissesKeyboard(.interactively)
        .listStyle(.plain)
    }
}

// MARK: - Constants


extension String {
    static let resourceName = "Conspiracies"
    static let resourceFromat = "json"
}

extension LocalizedStringKey {
    static let searchCategoryPickerTitle: Self = "Search Categories"
}

// MARK: - Preview

#if DEBUG
struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(searchText: .constant(""))
            .listStyle(.plain)
    }
}
#endif
