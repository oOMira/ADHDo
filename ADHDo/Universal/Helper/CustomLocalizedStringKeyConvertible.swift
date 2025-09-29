//
//  CustomLocalizedStringKeyConvertible.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 22.11.25.
//

import SwiftUI

/// Protocol for types that can provide a `LocalizedStringKey` representation.
protocol CustomLocalizedStringKeyConvertible {
    /// The `LocalizedStringKey` representation of the conforming value.
    var localizedStringKey: LocalizedStringKey { get }
}
