//
//  SoftwareComponentsView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 01.11.25.
//

import SwiftUI

/// Lists software-related components and settings (e.g. logging, analytics).
///
/// Each row navigates to a more detailed view; destinations can be changed to
/// dedicated screens as needed.
struct SoftwareComponentsView: View {
    var body: some View {
        List {
            // TODO: add ToS text
            NavigationLink(.loggingTitle) {
                ToSView(text: "Text")
            }

            NavigationLink(.analyticsTitle) {
                ToSView(text: "Text")
            }
        }
        .navigationTitle(.softwareComponentsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .contentMargins(.top, 4, for: .scrollContent)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let softwareComponentsTitle: Self = .init("Software")
    static let loggingTitle: Self = .init("Logging")
    static let analyticsTitle: Self = .init("Analytics")
}

// MARK: - Preview

#if DEBUG
struct SoftwareComponentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SoftwareComponentsView()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Software Components")
        }
    }
}
#endif
