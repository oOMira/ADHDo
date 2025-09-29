//
//  FocusItemAccessoryView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 25.10.25.
//

// TODO: Cleanup

import SwiftUI
import SwiftData

/// A small accessory view used to display a focused `ToDoItem` and quick actions.
///
/// This view shows a tappable circular status button and a details column with a title and subtitle.
/// It is intended to be used as a compact accessory (for example in a toolbar or a header) while an
/// item is focused.
///
/// Behavior notes
/// - The view owns a binding to the currently focused item (`currentItem`). When the
///   status button is pressed, the view toggles its local `selected` state and schedules
///   clearing the `currentItem` binding after a short delay (2 seconds) so the focus can
///   dismiss smoothly.
struct FocusItemAccessoryView: View {
    @Environment(\.modelContext) private var modelContext
    
    /// The currently focused `ToDoItem` shown by this accessory.
    /// Set this to `nil` to clear the accessory from its host view.
    @Binding var currentItem: ToDoItem?

    /// Local boolean representing the completed/selected state used by the state button.
    /// This is intentionally a local UI state and does not directly persist to the
    /// backing `ToDoItem` model in this view.
    @State var selected: Bool = false

    var body: some View {
        HStack {
            Button(action: pressDone, label: {
                Image(systemName: currentItem?.done ?? false ? .systemImage.circleFill.name : .systemImage.circle.name)
                    .font(.title2)
                    .foregroundStyle(.foreground)
            })
            .accessibilityHidden(true)
            
            VStack(alignment: .leading) {
                Text(currentItem?.title ?? "Title")
                    .font(.default.pointSize(16).weight(.semibold))
                if let subtitle = currentItem?.subtitle{
                    Text(subtitle)
                        .font(.default.pointSize(12))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityCustomContent("Done", selected ? "Is" : "Not")
    }

    /// Called when the accessory's state button is pressed.
    ///
    /// This toggles the local `selected` flag and schedules clearing the
    /// `currentItem` binding after a 2 second delay so the host UI can animate
    /// the dismissal if needed.
    func pressDone() {
        currentItem?.done.toggle()
        try? modelContext.save()
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            currentItem = nil
        }
    }
}

// MARK: - Preview

#if DEBUG
struct FocusItemAccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        FocusItemAccessoryView(currentItem: .init(.constant(.init(title: "Title"))))
            .previewLayout(.sizeThatFits)
    }
}
#endif
