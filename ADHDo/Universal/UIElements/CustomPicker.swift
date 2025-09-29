//
//  CustomPicker.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 04.11.25.
//

import SwiftUI

/// A small, reusable picker that renders a list of `selectionOptions` and
/// binds the selected item to `selection`.
///
/// `CustomPicker` is generic over the element type and the view used to render
/// each option. The `Element` must be `Hashable` and `Identifiable` so it can
/// be used with `ForEach`.
struct CustomPicker<Element: Hashable & Identifiable, Segment: View>: View {
    /// The currently selected value.
    @Binding private var selection: Element
    /// Builder that produces the view used to represent an option.
    @ViewBuilder private var segmentBuilder: (Element) -> Segment
    /// The list of selectable options shown in the picker.
    private let selectionOptions: [Element]
    /// Localized title used by the `Picker` and for accessibility purposes.
    private let title: LocalizedStringKey

    /// Create a generic `CustomPicker`.
    ///
    /// - Parameters:
    ///   - title: Localized title shown for the picker.
    ///   - selectionOptions: Array of elements to show as selectable options.
    ///   - selection: Binding to the currently selected element.
    ///   - segment: A view builder that renders a single option.
    init(title: LocalizedStringKey,
         selectionOptions: [Element],
         selection: Binding<Element>,
         @ViewBuilder segment: @escaping (Element) -> Segment) {
        self.title = title
        self._selection = selection
        self.selectionOptions = selectionOptions
        self.segmentBuilder = segment
    }

    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(selectionOptions) { option in
                segmentBuilder(option)
                    .tag(option)
                    .accessibilityIdentifier(Accessibility.option(for: option.id))
            }
        }
        .accessibilityIdentifier(Accessibility.picker(for: title))
        .accessibilityLabel(title)
    }
}

// MARK: - Initializer

extension CustomPicker where Element: CustomLocalizedStringKeyConvertible, Segment == Text {
    /// Convenience initializer for elements that can provide a `LocalizedStringKey`.
    init(title: LocalizedStringKey, selectionOptions: [Element], selection: Binding<Element>) {
        self.init(title: title, selectionOptions: selectionOptions, selection: selection) {
            Text($0.localizedStringKey)
        }
    }
}

extension CustomPicker where Element: CustomTextConvertible, Segment == Text {
    /// Convenience initializer for elements that can provide a `Text` view.
    init(title: LocalizedStringKey, selectionOptions: [Element], selection: Binding<Element>) {
        self.init(title: title, selectionOptions: selectionOptions, selection: selection) {
            $0.text
        }
    }
}

/// A protocol that provides a `Text` representation for a type.
protocol CustomTextConvertible {
    /// The `Text` representation of the conforming value.
    var text: Text { get }
}

// MARK: - Accessibility

private enum Accessibility {
    static func option(for id: Any) -> String { "customPicker_option_\(String(describing: id))" }
    static func picker(for title: LocalizedStringKey) -> String { "customPicker_\(String(describing: title))" }
}

// MARK: - Preview

#if DEBUG
struct CustomPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomPicker(title: "Test",
                     selectionOptions: SearchCategorie.allCases,
                     selection: .constant(SearchCategorie.allCases.first!))
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Custom Picker")
    }
}
#endif
