//
//  ExpandableEditCell+DatePicker.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 06.11.25.
//

import SwiftUI

extension ExpandableEditCell where EditSection == ExpandableView.DatePickerView,
                                   Value == Date {
    /// Convenience initializer for an `ExpandableEditCell` configured to edit
    /// `Date` values using `ExpandableView.DatePickerView` as the description view
    /// and `ExpandableView.TitleLabel` as the collapsed label.
    ///
    /// - Parameters:
    ///   - expanded: Optional binding controlling the expanded/collapsed state.
    ///   - oldDate: Binding to the previously saved date (optional).
    ///   - newDate: Binding to the editable date value.
    ///   - title: Localized title shown when the cell is collapsed.
    ///   - subtitle: Optional localized subtitle shown under the title.
    ///   - saveAction: Async action invoked when the primary/save button is tapped.
    init(expanded: Binding<Bool>,
         oldDate: Binding<Value?>,
         newDate: Binding<Value>,
         title: LocalizedStringKey,
         subtitle: LocalizedStringKey? = nil,
         saveAction: @escaping () async -> ExpandableView.CompletionState)
    {
        self.init(expanded: expanded,
                  title: title,
                  subtitle: subtitle,
                  oldValue: oldDate,
                  newValue: newDate,
                  description: { EditSection(date: newDate) },
                  saveAction: saveAction)
    }
}

extension ExpandableView {
    /// A small editor that shows a `DatePicker` with action buttons used by
    /// `ExpandableEditCell` when editing `Date` values.
    ///
    /// The view exposes `oldDate` and `newDate` bindings and runs the provided
    /// async `saveAction` when the primary action is triggered. It also exposes
    /// a clear action used by the helper `ButtonsArea` which restores the
    /// `newDate` to the `oldDate` when invoked.
    struct DatePickerView: View {
        /// Currently edited date value.
        @Binding var date: Date

        var body: some View {
            VStack {
                DatePicker(.dateTitle, selection: $date)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}

private extension LocalizedStringKey {
    static let dateTitle: Self = .init("Date")
    static let saveButtonTitle: Self = .init("Save")
    static let clearButtonTitle: Self = .init("Clear")
}

// MARK: - Preview

#if DEBUG
struct ExpandableDatePickerEditCell_Previews: PreviewProvider {
    static let date: Date = .init()
    static var previews: some View {
        Group {
            ExpandableEditCell(expanded: .constant(false),
                               oldDate: .constant(date),
                               newDate: .constant(date),
                               title: "Title",
                               saveAction: { () async -> ExpandableView.CompletionState in .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("collapsed cell")
            
            ExpandableEditCell(expanded: .constant(true),
                               oldDate: .constant(nil),
                               newDate: .constant(date),
                               title: "Title",
                               saveAction: { () async -> ExpandableView.CompletionState in .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("without old value")
            
            ExpandableEditCell(expanded: .constant(true),
                               oldDate: .constant(date),
                               newDate: .constant(date),
                               title: "Title",
                               saveAction: { () async -> ExpandableView.CompletionState in .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("with matching value")
            
            ExpandableEditCell(expanded: .constant(true),
                               oldDate: .constant(date),
                               newDate: .constant(.init()),
                               title: "Title",
                               saveAction: { () async -> ExpandableView.CompletionState in .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("without matching value")
        }
    }
}
#endif
