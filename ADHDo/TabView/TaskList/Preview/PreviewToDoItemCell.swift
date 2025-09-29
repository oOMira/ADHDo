//
//  PreviewToDoItemCell.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 14.10.25.
//

import SwiftUI
import SwiftData

/// A lightweight helper view used in previews and development to render a
/// configurable representation of a to-do item.
///
/// `PreviewToDoItemCell` accepts an optional `oldItem` (to show an edited
/// comparison) and a required `newItem`. When `oldItem` is provided a small
/// picker is shown allowing developers to toggle between the old and new
/// representations.
struct PreviewToDoItemCell: View {
    let oldItem: ItemConfiguration?
    let newItem: ItemConfiguration

    @State var previewType: PreviewType = .new
    @Environment(\.modelContext) private var modelContext

    /// Helper that returns the item to render based on `previewType`.
    var previewItem: ItemConfiguration {
        switch previewType {
        case .old: return oldItem ?? newItem
        case .new: return newItem
        }
    }

    var body: some View {
        VStack {
            PreviewToDoItemView(itemConfiguration: previewItem)
                // onChange provides the new value only; save when the value flips.
                .onChange(of: newItem.done) { old, new in
                    guard new != old else { return }
                    try? modelContext.save()
                }
                .onChange(of: newItem.favorite) { old, new in
                    guard new != old else { return }
                    try? modelContext.save()
                }

            if oldItem != nil {
                CustomPicker(title: "Preview type picker",
                             selectionOptions: PreviewType.allCases,
                             selection: $previewType)
                .pickerStyle(.palette)
            }
        }
    }
}

// MARK: - View Helper

/// Internal view that renders a `PreviewToDoItemCell.ItemConfiguration`.
private struct PreviewToDoItemView: View {
    /// The configuration used to render the preview row.
    let itemConfiguration: PreviewToDoItemCell.ItemConfiguration

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                let circleImage: String = itemConfiguration.done ? .systemImage.circleFill.name : .systemImage.circle.name
                Image(systemName: circleImage)
                    .foregroundStyle(.foreground)

                VStack(alignment: .leading) {
                    HStack {
                        Text(itemConfiguration.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if itemConfiguration.favorite {
                            Image(systemName: .systemImage.star.name)
                                .font(.footnote)
                                .padding(.horizontal, .spacing.medium.cgFloat)
                        }
                    }

                    Text(itemConfiguration.title.isEmpty ? .noTaskNamePlaceholder : itemConfiguration.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .italic(itemConfiguration.title.isEmpty)

                    if let description = itemConfiguration.subtitle, !description.isEmpty {
                        Text(description)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding(.vertical, .spacing.extraSmall.cgFloat)
    }
}

// MARK: - PreviewToDoItemCell+ItemConfiguration

extension PreviewToDoItemCell {
    /// Simple value type used to configure preview rows without relying on
    /// the full `ToDoItem` model.
    struct ItemConfiguration: Equatable {
        let timestamp: Date
        let title: String
        let subtitle: String?
        let favorite: Bool
        let done: Bool
    }
}

// MARK: - Constants

extension String {
    static let noTaskNamePlaceholder: Self = "Task Name"
}

// MARK: - Previews

#if DEBUG
struct PreviewToDoItemCell_Previews: PreviewProvider {
    static var sampleOld: PreviewToDoItemCell.ItemConfiguration {
        .init(timestamp: Date().addingTimeInterval(-3600),
              title: "Old Title",
              subtitle: "Old subtitle",
              favorite: true,
              done: false)
    }

    static var sampleNew: PreviewToDoItemCell.ItemConfiguration {
        .init(timestamp: Date(),
              title: "New Title",
              subtitle: "New subtitle",
              favorite: false,
              done: true)
    }

    static var previews: some View {
        Group {
            PreviewToDoItemCell(oldItem: nil, newItem: sampleNew)
                .previewDisplayName("Without old item")
                .previewLayout(.sizeThatFits)
            
            PreviewToDoItemCell(oldItem: sampleOld, newItem: sampleNew)
                .previewDisplayName("With old item")
                .previewLayout(.sizeThatFits)
        }
        .padding()
    }
}
#endif
