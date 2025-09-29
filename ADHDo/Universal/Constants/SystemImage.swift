//
//  SystemImage.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 02.11.25.
//

import SwiftUI

/// A centralized mapping of semantic image identifiers to SF Symbols names.
///
/// Use `SystemImage` anywhere in the app where an SF Symbol is required. The
/// enum provides a small, discoverable set of symbols used by the app and
/// avoids scattering raw string literals (`"arrow.up.right"`, etc.) throughout
/// the codebase. Use the `image` property to create a SwiftUI `Image` or
/// the `name` property when a `String` is required.
enum SystemImage: String {
    case arrowUp = "arrow.up.right"
    case brain = "brain.filled.head.profile"
    case camera = "camera.fill"
    case checkmark = "checkmark"
    case checkmarkCircle = "checkmark.circle"
    case circle = "circle"
    case circleFill = "circle.fill"
    case compass = "compass.drawing"
    case ellipsis = "ellipsis.circle"
    case exclamationmark = "exclamationmark.triangle"
    case external = "externaldrive"
    case eye = "eye"
    case gear = "gearshape.fill"
    case heart = "heart.fill"
    case list = "pencil.and.list.clipboard"
    case listAndClipboard = "list.clipboard"
    case listBullet = "list.bullet.rectangle.portrait"
    case pencil = "pencil"
    case plus = "plus"
    case person = "person"
    case shuffle = "shuffle"
    case star = "star"
    case starFill = "star.fill"
    case squareAndPencil = "square.and.pencil"
    case trash = "trash"
    case tray = "tray"
    case video = "video.fill"
    case xmark = "xmark"
}

// MARK: - Properties

extension SystemImage {
    /// Create a SwiftUI `Image` from the mapped SF Symbol name.
    var image: Image { .init(systemName: rawValue) }

    /// The underlying SF Symbol name as a `String`.
    var name: String { rawValue }
}

// MARK: - Typealias

// String
extension String {
    typealias systemImage = SystemImage
}

// Image
extension Image {
    typealias systemImage = SystemImage
}
