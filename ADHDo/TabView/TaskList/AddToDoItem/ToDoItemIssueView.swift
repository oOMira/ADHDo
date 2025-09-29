//
//  ToDoItemIssueView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 15.10.25.
//

import SwiftUI

/// Small inline view that displays an issue/warning message for a ToDo item.
///
/// Shows a prominent exclamation icon and a short localized description. Use
/// this view in forms to indicate validation problems or other item-specific
/// issues.
struct ToDoItemIssueView: View {
    /// Localized description text explaining the issue.
    let description: LocalizedStringKey

    var body: some View {
        HStack(spacing: .spacing.small.cgFloat) {
            Image(systemName: .systemImage.exclamationmark.name)
                .foregroundStyle(.yellow)
                .fontWeight(.bold)
            Text(description)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ToDoItemIssueView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemIssueView(description: "Test")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
