//
//  SupportView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 01.11.25.
//

import SwiftUI

// TODO: add functionality

/// A small view that allows users to support the developer via an in‑app purchase.
struct SupportView: View {
    var body: some View {
        VStack {
            HStack(spacing: .spacing.small.cgFloat) {
                let heart = {
                    Image(systemName: .systemImage.heart.name)
                        .accessibilityHidden(true)
                        .foregroundColor(.red)
                }
                heart()
                Text(.supportTitle)
                    .bold()
                    .accessibilityIdentifier(Accessibility.supportTitle)
                heart()
            }
            .accessibilityHidden(true)
            .padding(.bottom, .spacing.extraSmall.cgFloat)
            
            Text(.supportDescription)
                .accessibilityIdentifier(Accessibility.supportDescription)
                .foregroundStyle(.foreground)

            Button(action: {
                print("support pressed")
            }, label: {
                Text(.supportTitle)
                    .frame(maxWidth: .infinity)
            })
            .accessibilityIdentifier(Accessibility.supportButton)
            .padding(.top, .spacing.extraSmall.cgFloat)
            .buttonStyle(.borderedProminent)
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Accessibility

private enum Accessibility {
    static let supportButton = "supportView_supportButton"
    static let supportDescription = "supportView_supportDescription"
    static let supportTitle = "supportView_supportTitle"
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let supportTitle: Self = .init("Support Developer")
    static let supportDescription: Self = .init("This is an in-app purchase that won't give you any extra features, but it really helps me — please consider supporting the project!")
    static let supportButtonTitle: Self = .init("Support")
}

// MARK: - Preview

#if DEBUG
struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView()
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Support View")
    }
}
#endif
