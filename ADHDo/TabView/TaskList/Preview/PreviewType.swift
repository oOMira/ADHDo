//
//  PreviewType.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 04.11.25.
//

import SwiftUI

/// Represents which preview variant should be shown when rendering a
/// preview/sample ToDo item.
///
/// Use `PreviewType` in development UI to toggle between the "old" and
/// "new" representations of a row (for example when showing a diff between
/// previous and edited values). The type conforms to `LocalizedStringKey` so
/// it can be displayed directly in SwiftUI pickers, and to `CaseIterable` to
/// provide all available choices.
enum PreviewType: LocalizedStringKey, CaseIterable {
    case old = "Old"
    case new = "New"
}

// MARK: - PreviewType+Identifiable

extension PreviewType: Identifiable {
    var id: Self { self }
}

// MARK: - PreviewType+CustomLocalizedStringKeyConvertible

extension PreviewType: CustomLocalizedStringKeyConvertible {
    var localizedStringKey: LocalizedStringKey { self.rawValue }
}
