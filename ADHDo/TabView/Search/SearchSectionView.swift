//
//  SearchSectionView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 02.11.25.
//

import SwiftUI

/// A container view that shows either search results or suggestions depending
/// on the search state, and supports a "barrel roll" Easter-egg animation
/// when the user types the special trigger phrase into the search field.
///
/// When the environment value `isSearching` is true the view
/// presents `SearchResultsView` bound to `searchText`;
/// otherwise it shows `SearchSuggestionsView`.
struct SearchSectionView: View {
    /// Environment flag provided by SwiftUI that indicates whether the search
    /// field is active and the system is in searching mode.
    @Environment(\.isSearching) private var isSearching

    /// Two-way binding to the search text provided by the parent view.
    @Binding var searchText: String

    /// Internal rotation angle used to perform the barrel-roll animation.
    @State private var angle: Double = .zero

    var body: some View {
        NavigationStack {
            if isSearching {
                SearchResultsView(searchText: $searchText)
            } else {
                SearchSuggestionsView()
            }
        }
        .accessibilityIdentifier(Accessibility.root)
        .rotationEffect(.degrees(angle))
        .onChange(of: searchText, initial: true) { oldValue, newValue  in
            // Trigger rotation when the exact phrase (case-insensitive) is entered
            guard oldValue != newValue, newValue.lowercased() == .rotationTrigger else { return }
            rotate()
        }
    }
}

// MARK: - SearchSectionView+Helper

private extension SearchSectionView {
    /// Rotate the view 360 degrees
    func rotate() {
        withAnimation(.easeInOut(duration: .rotationInterval)) {
            angle = angle == .zero ? .oneRotation : .zero
        }
    }
}

// MARK: - Constants

private extension TimeInterval {
    static let rotationInterval: Self = 1.2
}

private extension Double {
    static let oneRotation: Self = 360
}

private extension String {
    /// Lowercased trigger phrase that starts the barrel-roll animation.
    static let rotationTrigger = "do a barrel roll"
}

// MARK: - Accessibility

private enum Accessibility {
    static let root = "searchSection_root"
}

// MARK: - Preview

#if DEBUG
struct SearchSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchSectionView(searchText: .constant(""))
                .previewDisplayName("Suggestions")
                .previewLayout(.sizeThatFits)

            SearchSectionView(searchText: .constant("do a barrel roll"))
                .previewDisplayName("Trigger Barrel Roll")
                .previewLayout(.sizeThatFits)
        }
    }
}
#endif
