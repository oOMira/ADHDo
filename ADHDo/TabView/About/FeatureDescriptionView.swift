//
//  FeatureDescriptionView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 31.10.25.
//

import SwiftUI

// TODO: Don't take view

/// A view that displays a feature's title, optional image, and descriptive text.
///
/// Use `FeatureDescriptionView` to present a single feature or concept on the About
/// screen. The view is configured using a `FeatureDescription.Configuration` value,
/// which supplies the title, description and an optional image
/// it is intended for read-only display only.
struct FeatureDescriptionView: View {
    let configuration: FeatureDescription.Configuration
    
    var body: some View {
        VStack(alignment: .leading) {
            configuration.title
                .font(.title)
            Divider()
            if let image = configuration.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 8)
            }
            configuration.description
        }
    }
}

// MARK: - Preview

#if DEBUG
struct FeatureDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        FeatureDescriptionView(configuration: .init(title: "Some Title",
                                                    description: "Some description",
                                                    image: .init("Hyperfocus")))
        .previewLayout(.sizeThatFits)
    }
}
#endif
