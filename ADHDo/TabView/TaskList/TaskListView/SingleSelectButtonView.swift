//
//  SingleSelectButtonView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 29.09.25.
//

import SwiftUI

/// A compact row of single-select buttons used to switch the current task filter.
///
/// Provide the available `TaskFilter` options and a binding to the currently
/// selected filter. The view renders one button per option, applying a
/// prominent style to the active selection. Accessibility identifiers and
/// hints are provided for UI testing and VoiceOver.
struct SingleSelectButtonView: View {
    let options: [TaskFilter]

    /// Two-way binding to the currently selected filter.
    @Binding var selection: TaskFilter

    var body: some View {
        ForEach(options, id: \.self) { option in
            Button {
                withAnimation(.easeInOut) { selection = option }
            } label: {
                HStack {
                    option.configuration.image
                    Text(option.title)
                        .font(.title3)
                }
            }
            .accessibilitySortPriority(selection == option ? 1 : 0)
            .accessibilityHint(selection == option ? Text("Selected") : Text(""))
            .accessibilityIdentifier(Accessibility.button(for: option.id))
            .borderedButtonStyle(selection == option ? .prominent : .regular)
            .tint(option.configuration.color)
        }
    }
}

extension SingleSelectButtonView {
    /// Lightweight configuration used to render a selection option.
    struct SelectionConfiguration: Identifiable {
        var id: String { title }
        let title: String
        let image: Image?
        let color: Color
    }
}

extension SingleSelectButtonView.SelectionConfiguration: Equatable {
    static func == (lhs: SingleSelectButtonView.SelectionConfiguration, rhs: SingleSelectButtonView.SelectionConfiguration) -> Bool {
        lhs.id == rhs.id
    }
}

extension SingleSelectButtonView.SelectionConfiguration: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Accessibility

private enum Accessibility {
    static func button(for id: String) -> String {
        return "taskFilter_button_\(id)"
    }
}

// MARK: - Preview

#if DEBUG
struct SingleSelectButtonView_Previews: PreviewProvider {
    static let options: [TaskFilter] = [.all, .todo, .done, .favorites]

    static var previews: some View {
        ScrollView(.horizontal) {
            HStack {
                SingleSelectButtonView(options: options,
                                       selection: .constant(.todo))
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Task Filter")
    }
}
#endif
