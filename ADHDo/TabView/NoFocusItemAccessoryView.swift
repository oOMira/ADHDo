//
//  NoFocusItemAccessoryView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 17.11.25.
//

import SwiftUI

/// A small accessory view shown when there is no currently focused item.
///
/// Use this view as a lightweight placeholder in places where a focused
/// item's accessory would normally appear (for example in a details pane).
struct NoFocusItemAccessoryView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text(.title)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(.subtitle)
                .font(.subtitle)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
        .padding()
    }
}

// MARK: - Constants

private extension Font {
    static let title: Self = .default.pointSize(16).weight(.semibold)
    static let subtitle: Self = .default.pointSize(12)
}

private extension LocalizedStringKey {
    static let title: Self = "No Item"
    static let subtitle: Self = "Select item to focus"
}
    
// MARK: - Preview

#if DEBUG
struct NoFocusItemAccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        NoFocusItemAccessoryView()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("No Focus Accessory")
    }
}
#endif
