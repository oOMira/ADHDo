//
//  DeveloperAppsView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 01.11.25.
//

import SwiftUI

// TODO: Replace constants

/// Lists the developer's other apps with an icon and name.
struct DeveloperAppsView: View {
    var body: some View {
        List {
            DeveloperAppView(name: "Some App", image: .systemImage.star.image)
            DeveloperAppView(name: "Another App", image: .systemImage.star.image)
        }
        .listStyle(.plain)
        .navigationTitle(.developerAppsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .contentMargins(.top, .spacing.extraSmall.rawValue, for: .scrollContent)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let developerAppsTitle: Self = .init("Developer Apps")
}

// MARK: - Preview

#if DEBUG
struct DeveloperAppsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DeveloperAppsView()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Developer Apps")
        }
    }
}
#endif
