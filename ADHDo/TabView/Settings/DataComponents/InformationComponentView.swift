//
//  InformationComponentView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 02.11.25.
//

import SwiftUI

/// A compact disclosure row that shows informational text and an optional link.
struct InformationComponentView: View {
    @State private var expanded: Bool
    private let title: LocalizedStringKey
    private let description: LocalizedStringKey
    private let url: URL
    
    /// Create an information component view.
    ///
    /// - Parameters:
    ///   - expanded: Initial expanded state. Defaults to `false` (collapsed).
    ///   - title: The primary title shown in the collapsed row. Prefer `LocalizedStringKey` for localization.
    ///   - description: A short supporting description shown below the title.
    init(expanded: Bool = false, title: LocalizedStringKey, description: LocalizedStringKey, urlString: String) throws {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        self.expanded = expanded
        self.title = title
        self.description = description
        self.url = url
    }
        
    var body: some View {
        DisclosureGroup(isExpanded: $expanded, content: {
            HStack {
                Text(url.absoluteString)
                Spacer()
                Image(systemName: .systemImage.arrowUp.name)
            }
        }, label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                    Text(description)
                        .font(.caption)
                }
                .padding(.horizontal, 4)
            }
        })
    }
}

// MARK: - Preview

#if DEBUG
struct InformationComponentView_Previews: PreviewProvider {
    static var previews: some View {
        try? InformationComponentView(
            title: "Title",
            description: "Description",
            urlString: "https://www.example.com"
        )
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Information Component")
    }
}
#endif
