//
//  VideoPlayerView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 02.11.25.
//

import SwiftUI
import AVKit

/// A reusable view that plays a local or remote video using `AVPlayer`.
///
/// Use this view on the About screen to display a random video. The view owns an `AVPlayer` instance.

struct VideoPlayerView: View {
    let url: URL
    private let player: AVPlayer
    private let frameHeight: CGFloat

    /// Create a new `VideoPlayerView`.
    ///
    /// - Parameters:
    ///   - url: The URL of the video to play.
    ///   - frameHeight: The height to use for the player view. Defaults to a sensible constant.
    init(url: URL, frameHeight: CGFloat = .frameHeight) {
        self.url = url
        self.frameHeight = frameHeight
        // Initialize the player once so it survives view updates.
        self.player = AVPlayer(url: url)
    }

    // MARK: - View body

    var body: some View {
        VideoPlayer(player: player)
            .cornerRadius(.cornerRadius)
            .frame(height: frameHeight)
            .onAppear { player.play() }
            .onDisappear { player.pause() }
            .accessibilityLabel(.accessibilityLabel)
            .accessibilityIdentifier(Accessibility.videoPlayer)
    }
}

// MARK: - Constants

extension LocalizedStringKey {
    static let accessibilityLabel: Self = .init("Video Player")
}

private extension CGFloat {
    static let cornerRadius: Self = .init(12)
    static let frameHeight: Self = .init(200)
}

// MARK: - Accessibility

private enum Accessibility {
    static let videoPlayer = "About.VideoPlayer.videoPlayer"
}

// MARK: - Preview

#if DEBUG
struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(url: Bundle.main.url(forResource: "AboutVideo", withExtension: "mov")!)
            .previewLayout(.sizeThatFits)
    }
}
#endif
