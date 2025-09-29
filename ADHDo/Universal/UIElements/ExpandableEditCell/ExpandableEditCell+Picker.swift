//
//  ExpandableEditCell+Picker.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 06.11.25.
//

import SwiftUI

extension ExpandableEditCell where EditSection == ExpandableView.PickerView<Value>,
                                   Value: Identifiable,
                                   Value: Hashable,
                                   Value: CustomLocalizedStringKeyConvertible {
    /// Convenience initializer for an `ExpandableEditCell` configured to edit
    /// a `PickerOption` value using `ExpandableView.PickerView` as the
    /// description view and `ExpandableView.TitleLabel` as the collapsed label.
    ///
    /// - Parameters:
    ///   - expanded: Optional binding controlling the expanded/collapsed state.
    ///   - oldSelection: Binding to the previously saved selection (optional).
    ///   - newSelection: Binding to the editable selection value.
    ///   - title: Localized title shown when the cell is collapsed.
    ///   - subtitle: Optional localized subtitle shown under the title.
    ///   - saveAction: Async action invoked when the primary/save button is tapped.
    init(expanded: Binding<Bool>,
         options: [Value],
         oldSelection: Binding<Value?>,
         newSelection: Binding<Value>,
         title: LocalizedStringKey,
         subtitle: LocalizedStringKey? = nil,
         saveAction: @escaping () async -> ExpandableView.CompletionState)
    {
        self.init(expanded: expanded,
                  title: title,
                  subtitle: subtitle,
                  oldValue: oldSelection,
                  newValue: newSelection,
                  description: { EditSection(options: options, selection: newSelection) },
                  saveAction: saveAction)
    }
}

// MARK: - EditPickerView

extension ExpandableView {
    /// A picker-based editor used by `ExpandableEditCell` when `Value` is
    /// any suitable `Option` type (must conform to `Hashable`, `Identifiable`
    /// and `CustomLocalizedStringKeyConvertible`).
    ///
    /// Shows a `CustomPicker` for selection and a `ButtonsArea` containing
    /// the primary (save) and optional clear/cancel buttons.
    struct PickerView<Option: Hashable & CustomLocalizedStringKeyConvertible & Identifiable>: View {
        /// Available options shown in the picker.
        let options: [Option]
        /// The currently edited selection.
        @Binding var selection: Option

        var body: some View {
            VStack(alignment: .leading) {
                CustomPicker(title: "Picker",
                             selectionOptions: options,
                             selection: $selection)
                    .pickerStyle(.wheel)
            }
        }
    }
}

enum SelectionOption<PickerOption: Hashable & CustomLocalizedStringKeyConvertible & Identifiable>: Hashable & CustomLocalizedStringKeyConvertible & Identifiable {
    
    case option(PickerOption)
    case none
}

extension SelectionOption {
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .option(let option): option.localizedStringKey
        case .none: .init("None")
        }
    }
    
    var id: AnyHashable {
        switch self {
        case .option(let option): return AnyHashable(option.id)
        case .none: return AnyHashable("SelectionOption.none")
        }
    }
    
    var option: PickerOption? {
        switch self {
        case .option(let option): return option
        case .none: return nil
        }
    }
}

// MARK: - Constants
private extension LocalizedStringKey {
    static let saveButtonTitle: Self = .init("Save")
    static let cancelButtonTitle: Self = .init("Cancel")
}


// TODO: delete

#if DEBUG
struct PickerOption: Hashable, Identifiable, CustomLocalizedStringKeyConvertible {
    /// Localized string key derived from the option title.
    var localizedStringKey: LocalizedStringKey { .init(title) }
    var id: String { title }
    let title: String

    init(_ title: String) {
        self.title = title
    }
}
#endif

#if DEBUG
extension PickerOption {
    /// The set of sample options used for previews.
    static let all: [Self] = [
        .init("Custom Category 1"),
        .init("Custom Category 2"),
        .init("Custom Category 3"),
        .init("Custom Category 4"),
        .init("Custom Category 5")
    ]
}
#endif


// MARK: - Preview

#if DEBUG
struct ExpandablePickerEditCell_Previews: PreviewProvider {
    static let date: Date = .init()
    static var previews: some View {
        Group {
            ExpandableEditCell(expanded: .constant(false),
                               options: PickerOption.all,
                               oldSelection: .constant(PickerOption.all.first!),
                               newSelection: .constant(PickerOption.all.first!),
                               title: "Title",
                               saveAction: { () async -> ExpandableView.CompletionState in .success },)
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("collapsed cell")

            ExpandableEditCell(expanded: .constant(true),
                               options: PickerOption.all,
                               oldSelection: .constant(nil),
                               newSelection: .constant(PickerOption.all.first!),
                               title: "Title",
                               saveAction: { () async -> ExpandableView.CompletionState in .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("without old value")

            ExpandableEditCell(expanded: .constant(true),
                               options: PickerOption.all,
                               oldSelection: .constant(PickerOption.all.first!),
                               newSelection: .constant(PickerOption.all.first!),
                               title: "Title",
                               saveAction: { () async -> ExpandableView.CompletionState in .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("with matching value")

            ExpandableEditCell(expanded: .constant(true),
                               options: PickerOption.all,
                               oldSelection: .constant(PickerOption.all.first!),
                               newSelection: .constant(PickerOption.all.last!),
                               title: "Title",
                               saveAction: { () async -> ExpandableView.CompletionState in .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("without matching value")
        }
    }
}
#endif
