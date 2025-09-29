//
//  TaskListView+SponsoredItemCell.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 21.11.25.
//

import SwiftUI

extension TaskListView {
    /// A lightweight placeholder row shown where a sponsored item will be displayed when not editing.
    struct SponsoredItemPlaceHolderCell: View {
        var body: some View {
            Text(.sponsoredItem)
                .frame(maxWidth: .infinity, alignment: .center)
                .deleteDisabled(true)
                .disabled(true)
        }
    }
}

extension TaskListView {
    /// A read-only sponsored item row used to represent promoted content in the task list.
    ///
    /// The cell wraps a `ToDoItemView` configured with a short advert title and
    /// marks the item as non-deletable and disabled so it cannot be edited by the user.
    struct SponsoredItemCell: View {
        let adConfiguration: AdvertConfiguration
        
        var body: some View {
            ToDoItemView(item: .init(timestamp: adConfiguration.date,
                                     title: adConfiguration.title,
                                     subtitle: adConfiguration.description)) { }
                .contentHint(type: .sponsored, placement: .bottomTrailing)
                .accessibilityElement(children: .combine)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) { }
                .disabled(true)
                .deleteDisabled(true)
                .accessibilityHint("Sponsored")
        }
    }
}

// MARK: - Constants

extension LocalizedStringKey {
    static let sponsoredItem: Self = .init("Sponsored Item")
}

// MARK: - Preview

#if DEBUG
struct SponsoredItemCell_Previews: PreviewProvider {
    static let advertConfig = AdvertConfiguration(date: Date(),
                                                  title: "Advert!",
                                                  description: "Some Advert")
    static var previews: some View {
        Group {
            TaskListView.SponsoredItemPlaceHolderCell()
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Sponsored Placeholder")

            TaskListView.SponsoredItemCell(adConfiguration: advertConfig)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Sponsored Item")
        }
    }
}
#endif
