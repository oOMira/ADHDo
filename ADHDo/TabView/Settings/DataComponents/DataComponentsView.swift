//
//  DataComponentsView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 01.11.25.
//

import SwiftUI

// TODO: Replace Constants

/// Aggregates data-related components such as informational links and resources.
///
/// The view composes `InformationComponentView` and `RessourceComponentView`
/// rows and exposes a navigation-friendly list for the Settings screen.
struct DataComponentsView: View {
    var body: some View {
        List {
            Section(.informationSectionTitle) {
                try? InformationComponentView(title: .conspiracyComponentTitle,
                                              description: "Wikipedia",
                                              urlString: "https://en.wikipedia.org/wiki/List_of_conspiracy_theories")
                try? InformationComponentView(title: .taskComponentTitle,
                                         description: "Website",
                                         urlString: "www.google.com")
            }
            Section(.resourcesSectionHeader) {
                // TODO: Replace URLs with real resources
                RessourceComponentView(title: "About Section Video", resourceType: .video, videoURL: .aboutVideo)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(.dataComponentsTitle)
        .accessibilityIdentifier(Accessibility.dataComponentsList)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let dataComponentsTitle: Self = .init("Data Components")
    static let informationSectionTitle: Self = .init("Information")
    static let conspiracyComponentTitle: Self = .init("Conspiracy")
    static let taskComponentTitle: Self = .init("Tasks")
    static let resourcesSectionHeader : Self = .init("Resources")
}

// MARK: - Accessibility

private enum Accessibility {
    static let dataComponentsList = "dataComponents_list"
}

// MARK: - Preview

#if DEBUG
struct DataComponentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DataComponentsView()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Data Components")
        }
    }
}
#endif
