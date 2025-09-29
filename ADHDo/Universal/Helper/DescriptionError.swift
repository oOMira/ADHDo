//
//  DescriptionError.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 13.11.25.
//

import SwiftUI

/// A simple error container that carries a textual description.
struct DescriptionError: Error {
    /// A short, human-readable description of the error.
    let description: String
}
