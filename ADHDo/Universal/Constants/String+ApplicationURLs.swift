//
//  String+ApplicationURLs.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 02.11.25.
//

import Foundation

extension String {
    /// Template for opening the App Store directly (iOS). Use this as a
    /// base to append the app identifier, e.g. `String.appStoreURL + "id<APP_ID>"`.
    static let appStoreURL = "itms-apps://itunes.apple.com/"

    /// Template for composing a new email via `mailto:` URL scheme. Replace the
    /// placeholder with a real support address before shipping.
    static let mailURL = "mailto:some@emailprovicer.com"
    
    static let videoURL = "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"
}

extension URL {
    static let aboutVideo = URL(string: .videoURL)!
}
