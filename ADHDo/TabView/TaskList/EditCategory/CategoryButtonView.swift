//
//  CategoryButtonView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 16.10.25.
//

import SwiftUI

/// A compact, tappable button used to represent and select a category in the
/// Edit Category UI.
///
/// The view displays a system icon and the category title. When `text` is
/// empty a short placeholder is shown. The control applies a tint color and a
/// bordered style that reflects `selected` state.
struct CategoryButtonView: View {
    let text: String
    let action: () -> Void
    let color: Color
    let selected: Bool

    /// Create a new `CategoryButtonView`.
    ///
    /// - Parameters:
    ///   - text: The category title to show. If empty, a placeholder string is displayed.
    ///   - selected: Controls the selected appearance (default: `false`).
    ///   - color: The tint color for icon and text (default: `.gray`).
    ///   - action: Closure invoked when the button is tapped.
    init(text: String, selected: Bool = false, color: Color = .gray, action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.color = color
        self.selected = selected
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: .systemImage.tray.name)
                Text(text.isEmpty ? .emptyPlaceholder : text)
                    .font(.title3)
                    .italic(text.isEmpty)
            }
        }
        .tint(color)
        .borderedButtonStyle(selected ? .prominent : .regular)
    }
}

// MARK: - Constants

extension String {
    static let emptyPlaceholder = "Category name"
}

// MARK: - Preview

#if DEBUG
struct CategoryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButtonView(text: "Category", action: { })
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
