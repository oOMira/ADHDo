//
//  RessourceComponentView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 02.11.25.
//

import SwiftUI
import AVKit

/// A reusable disclosure component that displays a resource (image/video/custom)
/// with an optional preview and action/link row.
///
/// The component is generic over the preview content and exposes convenience
/// initializers for common preview types (Image and Video).
struct RessourceComponentView<Preview: View>: View {
    @State private var expanded = false

    let title: LocalizedStringKey
    let resourceType: RessourceType
    let url: URL
    @ViewBuilder var preview: () -> Preview

    var body: some View {
        DisclosureGroup(isExpanded: $expanded, content: {
            VStack(spacing: .spacing.medium.rawValue) {
                preview()

                Divider()

                Button(url.absoluteString, systemImage: .systemImage.arrowUp.name) {
                    UIApplication.shared.open(url)
                }
            }
        }, label: {
            HStack {
                resourceType.icon
                VStack(alignment: .leading) {
                    Text(title)
                }
                .padding(.horizontal, .spacing.extraSmall.rawValue)
            }
        })
    }
}

// MARK: - RessourceComponentView+Image

extension RessourceComponentView where Preview == Image {
    /// Convenience initializer for image resources.
    init(title: LocalizedStringKey, resourceType: RessourceType, imageURL: URL, image: Image) {
        self.init(title: title, resourceType: resourceType, url: imageURL, preview: { image })
    }
}

// MARK: - RessourceComponentView+Video

extension RessourceComponentView where Preview == VideoPlayerView {
    /// Convenience initializer for video resources.
    init(title: LocalizedStringKey, resourceType: RessourceType, videoURL: URL) {
        self.init(title: title, resourceType: resourceType, url: videoURL, preview: {
            VideoPlayerView(url: videoURL)
        })
    }
}

// MARK: - RessourceComponentView+RessourceType

extension RessourceComponentView {
    /// The kind of resource represented by the view.
    enum RessourceType {
        /// A video resource.
        case video
        /// An image resource.
        case image
        /// A custom resource with a custom icon.
        case custom(icon: Image)

        /// The icon used for the resource type.
        var icon: Image {
            switch self {
            case .image: return .systemImage.camera.image
            case .video: return .systemImage.video.image
            case .custom(let image): return image
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RessourceComponentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RessourceComponentView(title: "Image",
                                   resourceType: .image,
                                   imageURL: URL(string: "https://example.com/video.mov")!,
                                   image: .systemImage.star.image)
            .previewDisplayName("Image")

            RessourceComponentView(title: "Video",
                                   resourceType: .video,
                                   videoURL: URL(string: "https://example.com/video.mov")!)
            .previewDisplayName("Video")

            RessourceComponentView(title: "Custom",
                                   resourceType: .custom(icon: .systemImage.star.image),
                                   url: URL(string: "https://example.com/video.mov")!,
                                   preview: { Text("Preview") })
            .previewDisplayName("Custom")
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
