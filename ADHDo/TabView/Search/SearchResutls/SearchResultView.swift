//
//  SearchResultView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 23.10.25.
//

import SwiftUI

/// A single row used to render a search result.
///
/// Use this lightweight view to display a localized title for a search result
/// in lists or pickers. The view exposes a single `text` property.
struct SearchResultView: View {
    /// The localized text to display for the search result.
    let searchResult: SearchResult

    var body: some View {
        VStack {
            Text(searchResult.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
            Text(searchResult.description)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview

#if DEBUG
struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(searchResult: .init(name: "Title", description: "Description"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
