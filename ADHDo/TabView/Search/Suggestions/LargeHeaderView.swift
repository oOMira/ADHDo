//
//  LargeHeaderView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 03.11.25.
//

import SwiftUI

/// A large, full-width header view used in the Search Suggestions screen.
///
/// Example usage:
/// ```swift
/// LargeHeaderView("Discover", backgroundColor: .blue)
/// ```
struct LargeHeaderView: View {
    private let title: LocalizedStringKey
    private let backgroundColor: Color
    private let height: CGFloat

    /// Create a new `LargeHeaderView`.
    ///
    /// - Parameters:
    ///   - title: Localized title to display in the header.
    ///   - backgroundColor: The header background color.
    ///   - height: The header height; defaults to `300` points.
    init(_ title: LocalizedStringKey,
         backgroundColor: Color,
         height: CGFloat = .defaultHeight)
    {
        self.title = title
        self.backgroundColor = backgroundColor
        self.height = height
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background
            Rectangle()
                .fill(backgroundColor.opacity(.opacity))
                .frame(height: height)

            // Title
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
        }
        .ignoresSafeArea()
    }
}
// MARK: - Constants

private extension Double {
    static let opacity: Self = 0.7
}

private extension CGFloat {
    static let defaultHeight: Self = 300
}


// MARK: - Preview

#if DEBUG
struct LargeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                LargeHeaderView("Title", backgroundColor: .red, height: 300)
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}
#endif
