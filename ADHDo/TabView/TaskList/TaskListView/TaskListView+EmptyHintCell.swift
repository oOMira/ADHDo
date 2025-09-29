//
//  TaskListView+EmptyHintCell.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 21.11.25.
//

import SwiftUI

extension TaskListView {
    /// A small hint cell shown when a category contains no items.
    struct EmptyHintCell: View {
        var body: some View {
            HStack {
                Text("😭")
                    .accessibilityHidden(true)
                Text(.emptyHintDescription)
                    .padding()
                Text("😭")
                    .accessibilityHidden(true)
            }
            .accessibilityElement(children: .combine)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.title2)
            .accessibilityIdentifier(Accessibility.emptyHintCell)
        }
    }
}

// MARK: - Accessibility

private enum Accessibility {
    static let emptyHintCell = "taskList_emptyHintCell"
}

// MARK: - Constants

extension LocalizedStringKey {
    static let emptyHintDescription: Self = .init("This category is empty")
}

// MARK: - Preview

#if DEBUG
struct TaskListView_EmptyHintCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView.EmptyHintCell()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
