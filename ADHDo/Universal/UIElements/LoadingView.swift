//
//  LoadingView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 10.11.25.
//

import SwiftUI

/// A view modifier that presents a loading overlay on top of the modified view.
///
/// The modifier disables user interaction of the underlying content while
/// loading is active and optionally shows a dimmed background behind a
/// `ProgressView`.
struct LoadingView: ViewModifier {
    /// The presentation style for the overlay.
    let type: LoadingType

    /// Binding flag that controls whether the loading overlay is visible.
    /// When `true` the modified content is disabled and the overlay is shown.
    @Binding var active: Bool

    func body(content: Content) -> some View {
        content.disabled(active)
            .overlay {
                if active {
                    ZStack {
                        switch type {
                        case .transparentOverlay:
                            Color.clear

                        case .dimmedOverlay:
                            Color.gray.opacity(.opacity)
                                .ignoresSafeArea()
                                .cornerRadius(.backgroundCornerRadius)
                        }

                        ProgressView()
                            .controlSize(.extraLarge)
                            .progressViewStyle(.circular)
                            .accessibilityIdentifier(Accessibility.progress)
                    }
                    .accessibilityIdentifier(Accessibility.overlay)
                } else {
                    EmptyView()
                }
            }
    }
}

// MARK: - LoadingView+LoadingType

extension LoadingView {
    /// The visual style of the loading overlay.
    enum LoadingType {
        /// A transparent overlay that blocks interaction but doesn't add
        /// a visible background.
        case transparentOverlay

        /// A dimmed overlay that displays a semi-opaque gray background
        /// behind the progress indicator.
        case dimmedOverlay
    }
}

// MARK: - View+Loading

extension View {
    /// Convenience modifier that applies a `LoadingView` to the view.
    ///
    /// - Parameters:
    ///   - active: Binding that toggles the overlay visibility.
    ///   - type: The overlay style to use (defaults to `.transparentOverlay`).
    /// - Returns: A view that shows a loading overlay while `active` is true.
    func loading(_ active: Binding<Bool>,
                 type: LoadingView.LoadingType = .transparentOverlay) -> some View {
        modifier(LoadingView(type: type, active: active))
    }
}

// MARK: - Accessibility

private enum Accessibility {
    static let overlay = "loadingView_overlay"
    static let progress = "loadingView_progress"
}

// MARK: - Constants

private extension Double {
    static let opacity: Self = 0.5
}

private extension CGFloat {
    static let backgroundCornerRadius: Self = 20
}

// MARK: - Preview

#if DEBUG
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Text("Element")
                .frame(width: 200, height: 200)
                .loading(.constant(false), type: .dimmedOverlay)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Regular")

            Text("Element")
                .frame(width: 200, height: 200)
                .loading(.constant(true), type: .dimmedOverlay)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Loading")
        }
    }
}
#endif

