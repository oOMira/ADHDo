import SwiftUI

/// A compact control that toggles a per-row inline editing UI in `CategoryCell`.
///
/// When `editing` is `false` the view shows a single edit icon (pencil). When
/// `editing` becomes `true` the control expands to reveal two option buttons:
/// a cancel (X) and a save (checkmark) action.
///
/// Usage:
/// - Provide a two-way `Binding<Bool>` for `editing` which represents whether
///   the row is currently in inline edit mode.
/// - Provide `cancelAction` and `saveAction` closures to perform cancel/save
///   behavior when the user taps the corresponding option buttons.
struct EditModeButton: View {
    @Binding var editing: Bool
    
    @Namespace private var animation
    private let animationID = "expandAnimation"
    
    let cancelAction: () -> Void
    let saveAction: () -> Void
    
    var body: some View {
        ZStack {
            if editing {
                // options
                HStack(alignment: .center) {
                    // abort
                    EditModeOptionButton(image: .xmark) {
                        withAnimation {
                            cancelAction()
                            withAnimation { editing.toggle() }
                        }
                    }
                    Divider()
                        .frame(height: .dividerHeight)
                        .padding(.vertical, .spacing.extraExtraSmall.cgFloat)
                    // save
                    EditModeOptionButton(image: .checkmark) {
                        withAnimation {
                            saveAction()
                            withAnimation { editing.toggle() }
                        }
                    }
                }
                .matchedGeometryEffect(id: animationID, in: animation)
            } else {
                // open edit mode
                EditModeOptionButton(image: .pencil) {
                    withAnimation { editing.toggle() }
                }
                .matchedGeometryEffect(id: animationID, in: animation)
            }
        }
        .background(.regularMaterial, in: .capsule)
    }
}

// MARK: - Helper

/// A small tappable button used inside `EditModeButton`.
///
/// Displays a single SF Symbol and forwards taps to the provided `action`.
/// The view is intentionally minimal (plain button style) and applies a small
/// padding consistent with the surrounding control.
private struct EditModeOptionButton: View {
    let image: SystemImage
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: image.name)
                .font(.title3)
        }
        .buttonStyle(.plain)
        .padding(.spacing.small.cgFloat)
    }
}

// MARK: - Constants

extension CGFloat {
    static let dividerHeight: Self = 28
}

// MARK: - Preview

#if DEBUG
struct EditModeButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditModeButton(editing: .constant(false)) { } saveAction: { }
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Regular State")
            EditModeButton(editing: .constant(true)) { } saveAction: { }
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Editing")
        }
    }
}
#endif
