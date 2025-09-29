//
//  ToSView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 02.11.25.
//

import SwiftUI

/// A simple view that displays the app's Terms of Service.
///
/// The view renders a single list section containing the legal text.
struct ToSView: View {
    /// The localized terms text displayed in the view.
    private let termsText: LocalizedStringKey
    
    /// Create a `ToSView` with the provided localized text.
    ///
    /// - Parameter termsText: The localized text shown inside the Terms of
    ///   Service section.
    init(text termsText: LocalizedStringKey) {
        self.termsText = termsText
    }
    
    var body: some View {
        List {
            Section(.termsOfServiceTitle) {
                Text(termsText)
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    /// Title displayed above the Terms of Service section.
    static let termsOfServiceTitle: Self = .init("Terms of Service")
}

// MARK: - Preview

#if DEBUG
/// Preview provider for the `ToSView` showing a sample long-form text.
struct ToSView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ToSView(text: .placeholder)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Terms of Service")
        }
    }
}
#endif

// TODO: clean up

#if DEBUG
extension LocalizedStringKey {
    static let placeholder: Self = """
                    Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.
"""
}
#endif
