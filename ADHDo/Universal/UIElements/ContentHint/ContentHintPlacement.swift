//
//  ContentHintPlacement.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 10.11.25.
//

import SwiftUI

/// Describes the placement of a small informational hint relative to some content.
///
/// Use one of the four compound cases to place the hint on a vertical (top/bottom)
/// and horizontal (leading/trailing) side of the content. The enum is intentionally
/// simple and can be decomposed using the `verticalPlacement` and
/// `horizontalAlignment` computed properties.
enum ContentHintPlacement {
    /// Place the hint at the top edge and align it to the leading side.
    case topLeading

    /// Place the hint at the top edge and align it to the trailing side.
    case topTrailing

    /// Place the hint at the bottom edge and align it to the leading side.
    case bottomLeading

    /// Place the hint at the bottom edge and align it to the trailing side.
    case bottomTrailing
}

extension ContentHintPlacement {
    /// The vertical (top / bottom) component of a `ContentHintPlacement`.
    ///
    /// Use this to decide whether the hint should be shown above or below
    /// the content.
    enum Vertical {
        /// The hint is placed above the content.
        case top

        /// The hint is placed below the content.
        case bottom
    }

    /// The vertical component extracted from this placement.
    ///
    /// - Returns: `.top` when the placement is one of the top variants,
    ///   `.bottom` for bottom variants.
    var verticalPlacement: Vertical {
        switch self {
        case .topLeading, .topTrailing: return .top
        case .bottomLeading, .bottomTrailing: return .bottom
        }
    }
}

extension ContentHintPlacement {
    /// The horizontal (leading / trailing) component of a `ContentHintPlacement`.
    ///
    /// Use this to decide how the hint's content should be aligned horizontally.
    enum Horizontal {
        /// Align hint content to the leading edge.
        case leading

        /// Align hint content to the trailing edge.
        case trailing
    }

    /// The horizontal component extracted from this placement.
    ///
    /// - Returns: `.leading` for leading variants and `.trailing` for
    ///   trailing variants.
    var horizontalAlignment: Horizontal {
        switch self {
        case .topLeading, .bottomLeading: return .leading
        case .topTrailing, .bottomTrailing: return .trailing
        }
    }
}
