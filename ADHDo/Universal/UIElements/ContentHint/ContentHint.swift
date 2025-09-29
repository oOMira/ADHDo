//
//  ContentHint.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 05.11.25.
//

import SwiftUI

/// The semantic type of a content hint displayed alongside a view.
enum ContentHintType {
    /// Indicates general advertisement content.
    case advert

    /// Marks content as sponsored.
    case sponsored

    /// Allows providing a custom label string.
    case custom(String)

    /// Human-readable title displayed inside the content hint.
    var title: String {
        switch self {
        case .advert: return "Advert"
        case .sponsored: return "Sponsored"
        case .custom(let title): return title
        }
    }
}

/// A small modifier that displays a short caption above or below a view to
/// provide contextual hints (for example, advertising or sponsored markers).
///
/// Use `contentHint(type:placement:)` on a view to show the hint in the
/// requested placement. The modifier is intentionally lightweight — it only
/// uses a `Text` caption and aligns it according to the provided
/// `ContentHintPlacement`.
struct ContentHint: ViewModifier {
    let type: ContentHintType
    let placement: ContentHintPlacement

    func body(content: Content) -> some View {
        VStack {
            let hint = Text(type.title)
                .frame(maxWidth: .infinity, alignment: textAlignment)
                .font(.caption)
                .accessibilityHidden(true)
            switch placement.verticalPlacement {
            case .top:
                hint
                content
            case .bottom:
                content
                hint
            }
        }
        .accessibilityIdentifier(Accessibility.hintText)
    }

    /// Map the horizontal placement to a SwiftUI `Alignment` used by the
    /// hint `Text`'s frame alignment.
    var textAlignment: Alignment {
        switch placement.horizontalAlignment {
        case .leading: .leading
        case .trailing: .trailing
        }
    }
}

extension View {
    /// Attach a small, descriptive content hint to this view.
    ///
    /// - Parameters:
    ///   - type: The hint type (advert, sponsored, or custom text).
    ///   - placement: Where the hint should be positioned relative to the view.
    func contentHint(type: ContentHintType, placement: ContentHintPlacement) -> some View {
        modifier(ContentHint(type: type, placement: placement))
    }
}

// MARK: - Accessibility

private enum Accessibility {
    static let hintText = "ContentHint.hintText"
}


// MARK: - Preview

#if DEBUG
struct ContentHint_Previews: PreviewProvider {
    static var previews: some View {
        Text("Element")
            .contentHint(type: .advert, placement: .bottomLeading)
            .previewLayout(.sizeThatFits)
    }
}
#endif
