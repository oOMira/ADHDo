//
//  DeveloperAppView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 02.11.25.
//

import SwiftUI

/// A single row that represents a developer app with an icon and a title.
///
/// `DeveloperAppView` displays a square icon on the leading edge and a
/// localized app name. Use this view inside lists to show other apps by the
/// developer.
struct DeveloperAppView: View {
    /// App name displayed next to the icon.
    let name: LocalizedStringKey
    /// App icon image; typically an `Image(systemName:)` or an asset image.
    let image: Image

    var body: some View {
        HStack(spacing: .spacing.extraSmall.rawValue) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: .frameWidth)
                .padding(.trailing, .padding)
                .accessibilityLabel(name)

            Text(name)
                .font(.title2)
                .fontWeight(.regular)

            Spacer()
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let frameWidth: Self = 25
    static let padding: Self = 8
}

// MARK: - Preview

#if DEBUG
struct DeveloperAppView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DeveloperAppView(name: "App Name",
                             image: .init(systemName: "star"))
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Developer App - Star")
                .padding()

            DeveloperAppView(name: "Another App",
                             image: .init(systemName: "app"))
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Developer App - App")
                .padding()
        }
    }
}
#endif
