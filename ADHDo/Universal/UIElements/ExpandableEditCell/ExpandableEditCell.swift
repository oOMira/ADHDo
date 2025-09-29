//
//  ExpandableEditCell.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 06.11.25.
//

import SwiftUI

typealias ExpandableEditCell<B: View, Value: Equatable> = ExpandableView.EditCell<B, Value>

/// Container namespace for the editable disclosure-based cell used throughout the app.
///
/// `ExpandableView` holds the nested `EditCell` view which implements a
/// collapsible/expandable editing UI: a collapsed label view and an expanded
/// description/editor view. The edit cell can optionally receive a binding to
/// control the expanded state externally.
struct ExpandableView {
    /// A generic editable cell that shows a label when collapsed and a
    /// description (editor) when expanded.
    ///
    /// Type parameters:
    /// - `EditSection`: The label view type shown when collapsed.
    /// - `Value`: The value type being edited (must conform to `Equatable`).
    struct EditCell<EditSection: View, Value: Equatable>: View {
        /// The previously saved value. Optional — `nil` represents no saved value.
        @Binding var oldValue: Value?
        /// The in-progress edited value.
        @Binding var newValue: Value
        
        private let label: ExpandableView.TitleLabel
        private let description: EditSection
        private let saveAction: () async -> ExpandableView.CompletionState
         
        @Binding private var expanded: Bool
        
        // MARK: Initializer
        
        /// Create a new edit cell.
        ///
        /// - Parameters:
        ///   - expanded: Optional binding controlling the expanded/collapsed state.
        ///   - oldValue: Binding to the previously saved value (optional).
        ///   - newValue: Binding to the in-progress edited value.
        ///   - title: The title displayed on the label
        ///   - subtitle: The subtitle displayed on the label
        ///   - description: View builder that returns the expanded description/editor.
        ///   - saveAction: Async action executed to persist the changed value.
        init(expanded: Binding<Bool>,
             title: LocalizedStringKey,
             subtitle: LocalizedStringKey? = nil,
             oldValue: Binding<Value?>,
             newValue: Binding<Value>,
             @ViewBuilder description: () -> EditSection,
             saveAction: @escaping () async -> ExpandableView.CompletionState)
        {
            self._expanded = expanded
            self._oldValue = oldValue
            self._newValue = newValue
            self.label = .init(title: title, subtitle: subtitle)
            self.description = description()
            self.saveAction = saveAction
        }
        
        var body: some View {
            DisclosureGroup(isExpanded: $expanded, content: {
                description
                ButtonsArea(showsProminentSave: oldValue != nil && isValid,
                            secondaryButtonState: state,
                            cancelAction: cancel,
                            clearAction: clear,
                            saveAction: saveAction)
                .listRowSeparator(.hidden, edges: .top)
            }, label: {
                AnyView(label.italic(oldValue != newValue))
            })
        }
        
        var state: ButtonsArea.SecondaryButtonState {
            if oldValue == nil, isValid {
                .save
            } else if oldValue != newValue, oldValue != nil {
                .clear
            } else {
                .cancel
            }
        }
        
        func cancel() {
            withAnimation { expanded.toggle() }
        }
        
        func clear()
        {
            withAnimation {
                guard let oldValue = oldValue else { return }
                newValue = oldValue
            }
        }
    }
}

// MARK: Helper

extension ExpandableEditCell {
    var isValid: Bool {
        let customValidate = (self as? (any CustomValueValidatable))?.validate()
        return customValidate ?? (newValue != oldValue)
    }
}


// MARK: - CustomValueValidatable

protocol CustomValueValidatable {
    func validate() -> Bool
}

// MARK: - Preview

#if DEBUG
struct ExpandableEditCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExpandableEditCell(expanded: .constant(false),
                               title: "Example",
                               subtitle: "A short subtitle",
                               oldValue: .constant(nil),
                               newValue: .constant("New"),
                               description: { Text("Description") },
                               saveAction: { .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Empty State - Collapsed")
            
            ExpandableEditCell(expanded: .constant(true),
                               title: "Example",
                               subtitle: "A short subtitle",
                               oldValue: .constant(nil),
                               newValue: .constant("New"),
                               description: { Text("Description") },
                               saveAction: { .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Empty State - Expanded")
            
            ExpandableEditCell(expanded: .constant(true),
                               title: "Example",
                               subtitle: "A short subtitle",
                               oldValue: .constant("Old"),
                               newValue: .constant("Old"),
                               description: { Text("Description") },
                               saveAction: { .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Matching State - Expanded")
            
            ExpandableEditCell(expanded: .constant(true),
                               title: "Example",
                               subtitle: "A short subtitle",
                               oldValue: .constant("Old"),
                               newValue: .constant("New"),
                               description: { Text("Description") },
                               saveAction: { .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Update State - Expanded")
        }
    }
}
#endif
