//
//  DismissButton.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 02.11.25.
//

import SwiftUI

/// A small, reusable button that dismisses the current presentation.
///
/// Use this view anywhere you need a standardized dismiss button (for
/// example in a toolbar or navigation bar). The button calls the environment
/// `dismiss()` action when tapped.
struct DismissButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Label(.closeTitle, systemImage: .systemImage.xmark.name)
                .accessibilityIdentifier(Accessibility.label)
        }
        .accessibilityIdentifier(Accessibility.button)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let closeTitle: Self = .init("Close")
}

// MARK: - Accessibility

private enum Accessibility {
    static let button = "dismissButton"
    static let label = "dismissButton_label"
}


#if DEBUG
struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DismissButton()
                .toolbar {
                    ToolbarItem {
                        DismissButton()
                    }
                }
        }
    }
}
#endif

