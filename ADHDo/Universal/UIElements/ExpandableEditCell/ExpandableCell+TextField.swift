//
//  ExpandableCell.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 04.11.25.
//

import SwiftUI

// MARK: TextField
extension ExpandableEditCell where EditSection == ExpandableView.TextFieldView,
                                   Value == String {
    /// Convenience initializer for an `ExpandableEditCell` configured to edit
    /// a `String` value using a `TextField` description view and a
    /// `TitleLabel` as the label.
    ///
    /// - Parameters:
    ///   - expanded: Optional binding controlling the expanded/collapsed state.
    ///   - oldText: Binding to the previously saved text (optional).
    ///   - newText: Binding to the editable text value.
    ///   - title: Localized title shown when the cell is collapsed.
    ///   - subtitle: Optional localized subtitle shown under the title.
    ///   - saveAction: Async action invoked when the primary/save button is tapped.
    init(expanded: Binding<Bool>,
         oldText: Binding<Value?>,
         newText: Binding<Value>,
         title: LocalizedStringKey,
         subtitle: LocalizedStringKey? = nil,
         saveAction: @escaping () async -> ExpandableView.CompletionState)
    {
        self.init(expanded: expanded,
                  title: title,
                  subtitle: subtitle,
                  oldValue: oldText,
                  newValue: newText,
                  description: { EditSection(text: newText) },
                  saveAction: saveAction)
    }
}


// MARK: - ExpandableEditCell+CustomValueValidatable
extension ExpandableEditCell: CustomValueValidatable where EditSection == ExpandableView.TextFieldView,
                                                           Value == String {
    func validate() -> Bool {
        (newValue != oldValue) && !newValue.isEmpty
    }
}

// MARK: TextField
extension ExpandableView {
    /// A compact editor that shows a `TextField` with action buttons used by
    /// `ExpandableEditCell` when editing `String` values.
    ///
    /// The view exposes `oldText` and `newText` bindings and runs the provided
    /// async `saveAction` when the primary action is triggered. It also exposes
    /// a clear action used by the helper `ButtonsArea`.
    struct TextFieldView: View {
        /// The currently edited value.
        @Binding var text: String
        
        var body: some View {
            VStack {
                TextField(.editTextFieldPlaceholder, text: $text)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let saveButtonTitle: Self = .init("Save")
    static let clearButtonTitle: Self = .init("Clear")
    static let editTextFieldPlaceholder: Self = .init("Edit")
}

// MARK: - Preview

#if DEBUG
struct ExpandableEditCellTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExpandableEditCell(expanded: .constant(false),
                               oldText: .constant("something"),
                               newText: .constant("something"),
                               title: "Title",
                               subtitle: "Subtitle",
                               saveAction: { () async -> ExpandableView.CompletionState in .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("collapsed cell")
            
            ExpandableEditCell(expanded: .constant(true),
                               oldText: .constant("something"),
                               newText: .constant("something"),
                               title: "Title",
                               subtitle: "Subtitle",
                               saveAction: { () async -> ExpandableView.CompletionState in .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("with matching old text")
            
            ExpandableEditCell(expanded: .constant(true),
                               oldText: .constant("something"),
                               newText: .constant("something new"),
                               title: "Title",
                               subtitle: "Subtitle",
                               saveAction: { () async -> ExpandableView.CompletionState in .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("without matching old text")
            
            ExpandableEditCell(expanded: .constant(true),
                               oldText: .constant(nil),
                               newText: .constant("something"),
                               title: "Title",
                               subtitle: "Subtitle",
                               saveAction: { () async -> ExpandableView.CompletionState in .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("without old text")
        }
    }
    
}
#endif
