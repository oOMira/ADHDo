//
//  SendLogsView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 01.11.25.
//

import SwiftUI

/// ToDO: Implement functionality to send logs to the developer.

/// View that displays log information and offers a button to send logs to the developer.
struct SendLogsView: View {
    let logs: String

    var body: some View {
        VStack {
            List {
                Section(.logsTitle) {
                    Text(logs)
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            Spacer()
            SendLogsButton {
                print("send pressed")
            }
        }
        .contentMargins(.top, .spacing.extraSmall.cgFloat, for: .scrollContent)
        .navigationTitle(.sendLogsTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - SendLogsButton

extension SendLogsView {
    struct SendLogsButton: View {
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(.sendLogsButtonTitle)
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let sendLogsTitle: Self = .init("Send Logs")
    static let sendLogsButtonTitle: Self = .init("Send Logs")
    static let logsTitle: Self = .init("Logs")
}

// MARK: - Preview

#if DEBUG
struct SendLogsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SendLogsView(logs: "Sample log entry 1\nSample log entry 2\nSample log entry 3")
                .previewLayout(.sizeThatFits)
        }
        .previewDisplayName("Send Logs")
    }
}
#endif
