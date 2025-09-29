//
//  ToDoItemDetailsView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 15.10.25.
//

import SwiftUI

struct ItemDetailsView: View {
    /// The `ToDoItem` whose details this view presents.
    ///
    /// The view renders a set of labeled rows (date, title, subtitle, category,
    /// favorite and done state) using `ItemDetailsElementView` so it can be
    /// embedded inside lists or forms.
    let item: ToDoItem
    var body: some View {
        ItemDetailsElementView(title: .dateTitle,
                               subtitle: "\(item.timestamp)")
            .listRowBackground(Color.clear)
        ItemDetailsElementView(title: .titleTitle,
                               subtitle: item.title)
            .listRowBackground(Color.clear)
        ItemDetailsElementView(title: .subtitleTitle,
                               subtitle: item.subtitle ?? .noDescriptionHint)
            .listRowBackground(Color.clear)
        ItemDetailsElementView(title: .categoryTitle,
                               subtitle: item.category?.name ?? .noCategoryHint)
            .listRowBackground(Color.clear)
        ItemDetailsElementView(title: .favoriteTitle,
                               subtitle: item.favorite ? .yesButtonTitle : .noButtonTitle)
            .listRowBackground(Color.clear)
        ItemDetailsElementView(title: .doneTitle,
                               subtitle: item.done ? .yesButtonTitle : .noButtonTitle)
            .listRowBackground(Color.clear)
    }
}

// MARK: - ItemDetailsElementView

private struct ItemDetailsElementView: View {
    let title: LocalizedStringKey
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.extraExtraSmall.cgFloat) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, .spacing.extraSmall.cgFloat)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let dateTitle: Self = "Date"
    static let titleTitle: Self = "Title"
    static let subtitleTitle: Self = "Subtitle"
    static let categoryTitle: Self = "Category"
    static let favoriteTitle: Self = "Favorite"
    static let doneTitle: Self = "Done"
}

extension String {
    static let yesButtonTitle: Self = "Yes"
    static let noButtonTitle: Self = "No"
    static let noDescriptionHint: Self = "No description"
    static let noCategoryHint: Self = "No category"
}

// MARK: - Preview

#if DEBUG
struct ItemDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultListPreviewView(style: .plain) {
            ItemDetailsView(item: .init(title: "New Item"))
        }
    }
}
#endif
