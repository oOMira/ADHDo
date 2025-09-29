//
//  ExapandableEditCellViewComponents.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 06.11.25.
//

import SwiftUI

// MARK: - Buttons

extension ExpandableView {
    /// A horizontal area containing the secondary and (optionally) prominent
    /// save button shown at the bottom of an expandable editor.
    ///
    /// The control forwards three actions:
    /// - `cancelAction` — called when the user cancels editing
    /// - `clearAction` — called when the user requests to clear the input
    /// - `saveAction`  — an async save closure that returns a completion state
    ///
    /// The `secondaryButtonState` controls the label and behaviour of the
    /// left-hand button (it can be a cancel, clear or save action). When
    /// `showsProminentSave` is true an additional prominent save button is
    /// displayed to the right.
    struct ButtonsArea: View {
        @Namespace var titleAnimation
        let showsProminentSave: Bool
        var secondaryButtonState: SecondaryButtonState

        let cancelAction: () -> Void
        let clearAction: () -> Void
        let saveAction: () async -> ExpandableView.CompletionState

        // Add animation
        var body: some View {
            ZStack {
                HStack {
                    // TODO: Animation for label
                    var isClear: Bool { secondaryButtonState == .clear }
                    Button(action: {
                        switch secondaryButtonState {
                        case .cancel: cancelAction()
                        case .clear: clearAction()
                        case .save: Task { await saveAction() }
                        }
                    }, label: {
                        Text(secondaryButtonState.title)
                            .frame(maxWidth: .infinity)
                    })
                    .borderedButtonStyle(.regular)
                    .accessibilityIdentifier(Accessibility.secondaryButton)

                    if showsProminentSave {
                        Button(action: {
                            Task { await saveAction() }
                        }, label: {
                            Text(.saveButtonTitle)
                                .frame(maxWidth: .infinity)
                        })
                        .borderedButtonStyle(.prominent)
                        .accessibilityIdentifier(Accessibility.saveButton)
                    }
                }
                .animation(.default, value: showsProminentSave)
            }
        }
    }
}

extension ExpandableView.ButtonsArea {
    /// State for the left-hand secondary button in the buttons area.
    enum SecondaryButtonState {
        /// Save using the left button.
        case save
        /// Clear the input using the left button.
        case clear
        /// Cancel editing using the left button.
        case cancel

        /// Localized title used for the button label.
        var title: LocalizedStringKey {
            switch self {
            case .save: return .saveButtonTitle
            case .clear: return .clearButtonTitle
            case .cancel: return .cancelButtonTitle
            }
        }
    }
}

// MARK: - Information Views

extension ExpandableView {
    /// A compact title/subtitle stack used as the header of the expandable cell.
    ///
    /// - `title`: required localized title.
    /// - `subtitle`: optional localized subtitle rendered below the title.
    struct TitleLabel: View {
        /// Localized main title.
        let title: LocalizedStringKey
        /// Optional localized subtitle shown below the title.
        let subtitle: LocalizedStringKey?

        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                if let subtitle {
                    Text(subtitle)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityIdentifier(Accessibility.titleLabel)
        }
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let saveButtonTitle: Self = .init("Save")
    static let clearButtonTitle: Self = .init("Clear")
    static let cancelButtonTitle: Self = .init("Cancel")
}

// MARK: - Accessibility IDs

private enum Accessibility {
    static let secondaryButton = "expandable_secondaryButton"
    static let saveButton = "expandable_saveButton"
    static let titleLabel = "expandable_titleLabel"
}

// MARK: - Preview

#if DEBUG
struct ExpandableView_Components_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExpandableView.ButtonsArea(showsProminentSave: true,
                                       secondaryButtonState: .clear,
                                       cancelAction: {},
                                       clearAction: {},
                                       saveAction: { .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Buttons Area - Prominent Save")

            ExpandableView.ButtonsArea(showsProminentSave: false,
                                       secondaryButtonState: .cancel,
                                       cancelAction: {},
                                       clearAction: {},
                                       saveAction: { .success })
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Buttons Area - No Prominent Save")
        }
    }
}
#endif
