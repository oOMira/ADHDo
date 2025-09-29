//
//  BookmarkSearchSuggestionView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 23.10.25.
//

import SwiftUI

/// A compact, tappable view that represents a saved bookmark
///
/// The view renders a visually styled row and opens the bookmark's URL when tapped.
struct BookmarkView: View {
    @State private var isErrorAlertPresented: Bool = false

    private let title: String
    private let url: URL?

    // MARK: Initializer

    /// Create a bookmark view from a `Bookmark` model.
    ///
    /// - Parameter bookmark: The `Bookmark` model whose `name` and `url` fields
    ///   will be used to populate the view.
    init(bookmark: Bookmark) {
        self.title = bookmark.name
        self.url = URL(string: bookmark.url)
    }

    /// Create a bookmark view from a title and a URL string.
    ///
    /// - Parameters:
    ///   - title: The user-visible name for the bookmark.
    ///   - urlString: The URL string; this will be converted to `URL` using
    ///     `URL(string:)`. If conversion fails, the view will show an error
    ///     alert when tapped.
    init(title: String, urlString: String) {
        self.title = title
        self.url = URL(string: urlString)
    }

    /// Create a bookmark view from a title and an already-resolved `URL`.
    ///
    /// - Parameters:
    ///   - title: The user-visible name for the bookmark.
    ///   - url: A valid `URL` to open when the row is tapped.
    init(title: String, url: URL) {
        self.title = title
        self.url = url
    }

    // MARK: View

    var body: some View {
        Button(action: openURL) {
            BookmarkCell(title: title)
        }
        .alert(.errorTitle, isPresented: $isErrorAlertPresented) {
            Button(.okButtonTitle, role: .cancel) { }
        } message: {
            Text(.invalidURLDescription)
        }
    }
}

// MARK: - Helper

extension BookmarkView {
    /// Attempt to open the bookmark's URL. If the URL is missing or invalid this
    /// method will present an error alert instead of attempting to open it.
    private func openURL() {
        if let url = url {
            UIApplication.shared.open(url)
        } else {
            isErrorAlertPresented.toggle()
        }
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let invalidURLDescription: Self = .init("The store URL is invalid")
    static let okButtonTitle: Self = .init("OK")
    static let errorTitle: Self = .init("Error")
}

// MARK: - Preview

#if DEBUG
struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView(title: "Google", urlString: "https://www.google.com")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
