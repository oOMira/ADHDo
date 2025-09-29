//
//  SearchSuggestionDetailsView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 03.11.25.
//

import SwiftUI

/// Shows a detailed, scrollable presentation for a single search suggestion.
///
/// The view composes a `LargeHeaderView` and a multiline description. Use this
/// view to present more information about a suggestion selected from
/// `SearchSuggestionsView`.
struct SearchSuggestionDetailsView: View {
    /// Configuration model that provides title, color and description for the view.
    let configuration: SearchSuggestionsConfiguration

    var body: some View {
        ScrollView {
            LargeHeaderView(configuration.title, backgroundColor: configuration.color)
                .accessibilityIdentifier(Accessibility.header)

            Text(configuration.description)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .multilineTextAlignment(.leading)
                .accessibilityIdentifier(Accessibility.description)

        }
        .ignoresSafeArea()
        .accessibilityIdentifier(Accessibility.scrollView)
    }
}

// MARK: - Accessibility

private enum Accessibility {
    static let header = "searchSuggestionDetails_header"
    static let description = "searchSuggestionDetails_description"
    static let scrollView = "searchSuggestionDetails_scrollView"
}

// MARK: - Preview

#if DEBUG
struct SearchSuggestionDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSuggestionDetailsView(configuration: .init(color: .red,
                                                         title: "Title",
                                                         description: "A longer description explaining the suggestion in detail. This text is multiline and shows how the view wraps content."))
            .previewDisplayName("Suggestion Details")
            .previewLayout(.sizeThatFits)
    }
}
#endif
