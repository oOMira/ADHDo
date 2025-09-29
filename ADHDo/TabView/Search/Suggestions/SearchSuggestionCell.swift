//
//  SearchSuggestionView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 03.11.25.
//

import SwiftUI

/// A tappable suggestion row used in the Search Suggestions screen.
struct SearchSuggestionCell: View {
    /// Configuration that provides title, description and color for the suggestion.
    let configuration: SearchSuggestionsConfiguration

    /// Action to run when the suggestion is tapped.
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                Text(configuration.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier(Accessibility.title)

                Text(configuration.description)
                    .accessibilityHidden(true)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier(Accessibility.description)
            }
            .contentHint(type: .advert, placement: .topLeading)
            .accessibilityCustomContent("Description", configuration.description)
            .frame(maxWidth: .infinity)
            .padding(.spacing.medium.cgFloat)
            .background(
                RoundedRectangle(cornerRadius: .backgroundCornerRadius, style: .continuous)
                    .fill(configuration.color.opacity(.colorOpacity))
                    .shadow(color: .black.opacity(.shadowOpacity), radius: .shadowRadius, y: .shadowOffset)
            )
        }
        .accessibilityIdentifier(Accessibility.button)
    }
}

// MARK: - Accessibility

private enum Accessibility {
    static let title = "searchSuggestion_title"
    static let description = "searchSuggestion_description"
    static let button = "searchSuggestion_button"
}

// MARK: - Constants

private extension Double {
    static let shadowOpacity: Self = 0.08
    static let colorOpacity: Self = 0.7
}

private extension CGFloat {
    static let backgroundCornerRadius: Self = 20
    static let shadowRadius: Self = 8
    static let shadowOffset: Self = 4
}

// MARK: - Preview

#if DEBUG
struct SearchSuggestionView_Previews: PreviewProvider {
    static let config = SearchSuggestionsConfiguration.defaultConfig.first!

    static var previews: some View {
        DefaultListPreviewView {
            SearchSuggestionCell(configuration: config) {
                // Preview action
            }
            .listRowSeparator(.hidden)
        }
        .previewDisplayName("Search Suggestion")
    }
}
#endif
