//
//  BookmarkView+Subviews.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 22.11.25.
//

import SwiftUI

// MARK: BookmarkListView

// Whats that and why here
/// A cell view that renders the bookmark title and provides layout details for the row.
extension BookmarkView {
    struct BookmarkCell: View {
        /// The title text displayed in the cell.
        let title: String
        
        var body: some View  {
            VStack(alignment: .leading,
                   spacing: .spacing.small.cgFloat) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(.spacing.medium.cgFloat)
            .background {
                BackgroundView()
            }
        }
    }
}

// MARK: BackgroundView

extension BookmarkView {
    struct BackgroundView: View {
        var body: some View  {
            RoundedRectangle(cornerRadius: .backgroundRadius, style: .continuous)
                .fill(.gray.opacity(.backgroundOpacity))
                .shadow(color: .black.opacity(.shadowOpacity), radius: .shadowRadius, y: .shadowOffest)
        }
    }
}

// MARK: - Constants

private extension CGFloat {
    static let backgroundRadius: Self = 20
    static let shadowRadius: Self = 8
    static let shadowOffest: Self = 4
}

private extension Double {
    static let shadowOpacity: Self = 0.08
    static let backgroundOpacity: Self = 0.5
}

#if DEBUG
struct BookmarkView_Subviews_Previews: PreviewProvider {
    private typealias BookmarkCell = BookmarkView.BookmarkCell
    
    static var previews: some View {
        Group {
            BookmarkCell(title: "Title")
                .previewLayout(.sizeThatFits)
        }
    }
}
#endif
