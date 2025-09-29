//
//  AddNewCategoryView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 14.11.25.
//

import SwiftUI
import SwiftData

/// A small editor view that lets the user create a new `Category`.
///
/// Presents a live preview of the category button, a text field for the
/// category name and simple Cancel / Add controls. The view inserts a new
/// `Category` into the environment `ModelContext` when the user taps Add.
struct AddNewCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State var text: String = ""
    @State var previewSelected: Bool = false
    let cancelable: Bool
    
    let cancelAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.medium.cgFloat) {
            // Preview
            CategoryButtonView(text: text, selected: previewSelected) {
                withAnimation { previewSelected.toggle() }
            }
            .accessibilityHint("Preview")
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentHint(type: .custom(.previewTitle), placement: .topLeading)
            
            Divider()
                .frame(maxWidth: .infinity,
                       minHeight: .spacing.extraSmall.cgFloat)
            
            // Edit Area
            TextField(.categoryTextFieldTitle, text: $text)
                .textFieldStyle(.roundedBorder)
            
            // Contorls Area
            AddNewCategoryViewContols(cancelable: cancelable, cancelAction: {
                text = .init()
                cancelAction()
            }, saveAction: {
                withAnimation {
                    modelContext.insert(Category(name: text))
                    try? modelContext.save()
                    text = .init()
                    cancelAction()
                }
            })
        }
    }
}

// MARK: View Components

private struct AddNewCategoryViewContols: View {
    let cancelable: Bool
    let cancelAction: () -> Void
    let saveAction: () -> Void
    
    var body: some View {
        HStack {
            if cancelable {
                Button(action: cancelAction) {
                    Text(.cancelTitle)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }

            
            Button(action: saveAction) {
                Text(.addTitle)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let addTitle: Self = .init("Add")
    static let cancelTitle: Self = .init("Cancel")
    static let categoryTextFieldTitle: Self = .init("Category")
}

extension String {
    static let previewTitle = "Preview"
}

// MARK: - Preview

#if DEBUG
struct AddNewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddNewCategoryView(cancelable: true) { }
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Cancelable")
            AddNewCategoryView(cancelable: false) { }
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Not cancelable")
        }
    }
}
#endif
