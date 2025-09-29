//
//  AboutSectionView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 11.10.25.
//

import SwiftUI
import AVKit

/// A SwiftUI view that displays the About section of the app, including a random video to keep your dopamin high, project description, and feature highlights.
///
/// The main content consists of:
/// - An embedded video player at the top
/// - Project description information
/// - A list of features with descriptions
///
/// Used as a section within the app to inform users about its purpose and capabilities.

struct AboutSectionView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(content: {
                    ProjectDescriptionView()
                        .accessibilityIdentifier(Accessibility.projectDescription)
                    ForEach(FeatureDescription.allCases, id: \.self) { feature in
                        FeatureDescriptionView(configuration: feature.configuration)
                            .listRowSeparator(.hidden)
                            .accessibilityIdentifier(Accessibility.featureDescription(feature.rawValue))
                    }
                }, header: {
                    VideoPlayerView(url: .aboutVideo)
                        .listRowInsets(.top, .zero)
                        .accessibilityIdentifier(Accessibility.videoPlayer)
                })
            }
            .listStyle(.plain)
            .navigationTitle(.navigationTitle)
            .contentMargins(.top, .zero, for: .scrollContent)
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}

// MARK: - Constants

// Text
private extension Text {
    static let navigationTitle: Self = .init("About")
}

// MARK: - Accessibility

private enum Accessibility {
    static let projectDescription = "AboutSection.ProjectDescription"
    static func featureDescription(_ id: String) -> String { "AboutSection.FeatureDescription.\(id)" }
    static let videoPlayer = "AboutSection.VideoPlayer"
}

// MARK: - Preview

#if DEBUG
struct AboutSectionView_Previews: PreviewProvider {
    static var previews: some View {
        AboutSectionView()
    }
}
#endif
