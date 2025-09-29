//
//  NoBookmarksHintCell.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 22.11.25.
//

import SwiftUI

/// A small placeholder view shown when the user has no bookmarks.
///
/// The view displays an emoji + short explanatory text centered in the row.
/// It's used as an inline placeholder in lists where bookmarks would appear.
struct NoBookmarksHintView: View {
    var body: some View {
        HStack {
            Text(.bookEmoji)
                .accessibilityHidden(true)
            Text(.noBookmarksHint)
            Text(.bookEmoji)
                .accessibilityHidden(true)
        }
        .accessibilityElement(children: .combine)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        .accessibilityIdentifier(Accessibility.noBookmarksHint)
    }
}

// MARK: - Accessibility

private enum Accessibility {
    static let noBookmarksHint = "search_noBookmarksHint"
}

// MARK: - Constants

extension LocalizedStringKey {
    static let noBookmarksHint: Self = .init("Your bookmarks will appear here")
    static let bookEmoji: Self = .init("📖")
}

// MARK: - Preview

#if DEBUG
struct NoBookmarksHintView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NoBookmarksHintView()
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("No Bookmarks - Light")

            NoBookmarksHintView()
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.dark)
                .previewDisplayName("No Bookmarks - Dark")
        }
    }
}
#endif
