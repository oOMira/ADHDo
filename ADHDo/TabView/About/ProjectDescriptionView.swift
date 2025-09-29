//
//  ProjectDescriptionView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 01.11.25.
//

import SwiftUI

/// A lightweight view that displays the project's description text used on the About screen.
struct ProjectDescriptionView: View {
    var body: some View {
        Text(.projectDescription)
            .padding()
            .accessibilityIdentifier("About.ProjectDescription.descriptionText")
            .accessibilityLabel("Project description")
    }
}

// MARK: - Constants

private extension AttributedString {
    static let projectDescription: AttributedString = """
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy
eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam
voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet
clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy
eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam
voluptua.
"""
}

// MARK: - Preview

#if DEBUG
struct ProjectDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultListPreviewView(style: .plain) {
            ProjectDescriptionView()
        }
        .listStyle(.plain)
    }
}
#endif
