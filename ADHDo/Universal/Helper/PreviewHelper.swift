//
//  PreviewHelper.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 17.11.25.
//

import SwiftUI

#if DEBUG
/// A lightweight preview container that wraps content inside a `NavigationStack`.
///
/// Use `DefaultPreviewView` in SwiftUI previews to provide a consistent
/// surrounding environment (navigation title, spacing, etc.) for view
/// snapshots. The view accepts a `ViewBuilder` closure producing the content.
struct DefaultPreviewView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            content.navigationTitle("Title")
        }
    }
}
#endif

#if DEBUG
/// A convenience preview container that places the provided content inside a
/// `List` and applies the requested `ListStyle`.
///
/// Useful for previewing views that are typically embedded in lists so the
/// visual context (row separators, inset behavior) matches the real usage.
struct DefaultListPreviewView<Content: View, Style: ListStyle>: View {
    let content: Content
    let listStyle: Style
    
    init(style listStyle: Style = .plain, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.listStyle = listStyle
    }
    
    var body: some View {
        DefaultPreviewView {
            List {
                content
            }
            .listStyle(listStyle)
        }
    }
}
#endif

#if DEBUG
/// A convenience preview container that places the provided content inside a
/// `ScrollView` and wraps it in the default preview environment.
struct DefaultScrollPreviewView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        DefaultPreviewView {
            ScrollView {
                content
            }
        }
    }
}
#endif
