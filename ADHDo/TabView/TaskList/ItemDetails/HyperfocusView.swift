//
//  HyperfocusView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 07.10.25.
//

import SwiftUI
import Combine

/// A lightweight view that presents a "hyperfocus" session for a single
/// `ToDoItem`.
///
/// The view displays the item details and a small toolbar that shows the
/// remaining countdown time. The `remainingTime` binding is updated by the
/// owning controller (for example a `HyperFocusConfiguration`) and the view
/// exposes controls to slightly adjust the timer (penalty/extension).
struct HyperFocusView: View {
    let item: ToDoItem

    /// Binding to the remaining countdown time in seconds. The owning
    /// view-model or configuration object should drive changes to this value.
    @Binding var remainingTime: Double

    var body: some View {
        NavigationStack {
            List {
                ItemDetailsView(item: item)
            }
            .toolbarTitleDisplayMode(.large)
            .navigationTitle(.title)
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    ShuffleButton(remainingTime: $remainingTime)
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    if remainingTime > 0 {
                        Text("\(Int(remainingTime))")
                    }
                    DismissButton()
                }
            }
        }
    }
}

// MARK: - View Components

/// A small button that applies a short penalty (adds seconds) to the
/// remaining hyperfocus time.
private struct ShuffleButton: View {
    /// Binding to the session remaining time treated in seconds.
    @Binding var remainingTime: Double

    var body: some View {
        Button {
            remainingTime += .penaltyTime
        } label: {
            Image(systemName: .systemImage.shuffle.name)
                .accessibilityIdentifier(Accessibility.shuffleButton)
        }
    }
}

// MARK: - Constants

private extension Double {
    static let penaltyTime: Self = 2
}

private extension LocalizedStringKey {
    static let title: Self = "Hyperfocus"
}

// MARK: - Accessibility

private enum Accessibility {
    static let shuffleButton = "hyperfocus_shuffleButton"
}

// MARK: - Preview

#if DEBUG
struct HyperFocusView_Previews: PreviewProvider {
    static var previews: some View {
        HyperFocusView(item: .init(title: "Title"),
                       remainingTime: .constant(20))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
