//
//  ToDoItem.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 28.09.25.
//

import SwiftUI
import SwiftData

/// A view that displays a single to-do item.
///
/// This view is used to render each row in the to-do list, showing the item's
/// title, subtitle, timestamp, and completion status. It also provides an
/// inline action control to mark the item as done or not done.
struct ToDoItemView: View {
    var item: ToDoItem
    let saveAction: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Button(action: {
                    saveAction?()
                }) {
                    Image(systemName: .circle(filled: item.done))
                        .foregroundStyle(.foreground)
                }
                .accessibilityHidden(true)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if item.favorite {
                            Image(systemName: .systemImage.starFill.name)
                                .font(.footnote)
                                .padding(.horizontal, .spacing.medium.cgFloat)
                        }
                    }
                    .accessibilityHidden(true)
                    Text(item.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let description = item.subtitle?.description {
                        Text(description)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityCustomContent("Creation date", "\(item.timestamp)")
            .accessibilityCustomContent("Favorite", "\(item.favorite ? "Is" : "Not")")
            .accessibilityCustomContent("Done", "\(item.done ? "Is" : "Not")")
        }
    }
}

// MARK: - Helper

private extension String {
    static func circle(filled: Bool) -> Self {
        filled ? .systemImage.circleFill.name : .systemImage.circle.name
    }
}

// MARK: - Preview

#if DEBUG
struct ToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemView(item: .init(title: "Title")) { }
            .previewLayout(.sizeThatFits)
            .previewDisplayName("without hint")

        ToDoItemView(item: .init(title: "Title")) { }
            .contentHint(type: .sponsored, placement: .bottomTrailing)
            .disabled(true)
            .previewDisplayName("with hint")
            .previewLayout(.sizeThatFits)
    }
}
#endif
