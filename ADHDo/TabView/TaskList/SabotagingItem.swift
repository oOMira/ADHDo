//
//  SabotagingItem.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 18.11.25.
//

import SwiftUI

/// A placeholder row that intentionally appears when content is hidden.
///
/// `SabotagingItem` is used in the task list when an item is intentionally
/// hidden from the regular feed (for example to simulate an invisible or
/// placeholder element). The row is visually disabled and cannot be
/// interacted with
struct SabotagingItem: View {
    var body: some View {
        HStack {
            Image(systemName: .systemImage.circleFill.name)
                .accessibilityHidden(true)
            // Minor grammar fix: make the sentence clearer for VoiceOver and UI
            Text("Something you did, but forgot")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .disabled(true)
        .deleteDisabled(true)
    }
}

#if DEBUG
struct SabotagingItem_Previews: PreviewProvider {
    static var previews: some View {
        SabotagingItem()
            .previewLayout(.sizeThatFits)
    }
}
#endif
