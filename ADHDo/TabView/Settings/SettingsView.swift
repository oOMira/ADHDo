//
//  SettingsView.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 29.09.25.
//

import SwiftUI
import UIKit

// TODO: functionality

/// The main Settings screen used in the app's TabView.
///
/// This view composes a list of configuration and informational sections:
/// - Support and engagement actions
/// - Developer / debug information (software/data/components)
/// - Privacy toggles
struct SettingsView: View {
    // Local feature toggles (stateful UI)
    @State private var cloudSync = true
    @State private var crashReports = false
    @State private var errorReports = false

    var body: some View {
        NavigationStack {
            List {
                // Support Section
                Section {
                    SupportView()
                }

                // Engagement Section
                Section {
                    ExternalLinkElement(title: .rateAppTitle,
                                        systemImageName: .systemImage.star.name,
                                        urlString: .appStoreURL)
                    ExternalLinkElement(title: .sendFeedbackTitle,
                                        systemImageName: .systemImage.pencil.name,
                                        urlString: .mailURL)
                }

                // Development Details Section
                Section(.developmentTitle) {
                    SubmenuElement(title: .softwareComponentsTitle,
                                   systemImageName: .systemImage.compass.name) {
                        SoftwareComponentsView()
                    }

                    SubmenuElement(title: .dataComponentsTitle,
                                   systemImageName: .systemImage.external.name) {
                        DataComponentsView()
                    }

                    SubmenuElement(title: .developerAppsTitle,
                                   systemImageName: .systemImage.person.name) {
                        DeveloperAppsView()
                    }

                    SubmenuElement(title: .sendLogTitle,
                                   systemImageName: .systemImage.list.name) {
                        SendLogsView(logs: "logs")
                    }
                }

                // Privacy Section
                Section(.privacyTitle) {
                    Toggle(.analyticsTitle, isOn: $errorReports)
                    Toggle(.iCloudSyncingTitle, isOn: $cloudSync)
                }

                ResetButton(action: deleteAppData)
            }
            .contentMargins(.top, .spacing.extraSmall.cgFloat, for: .scrollContent)
            .navigationTitle(.navigationBarTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - SettingsView+Helper

extension SettingsView {
    /// Deletes application data and resets relevant state.
    func deleteAppData() {
        
    }
}

extension SettingsView {
    struct ResetButton: View {
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(.deleteDataButtonTitle)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: - ExternalLinkElement

/// A simple row that opens an external URL when tapped.
///
/// This private helper displays a leading SF Symbol, a title and a trailing
/// external link indicator..
private struct ExternalLinkElement: View, Identifiable {
    let id = UUID()
    private let title: LocalizedStringKey
    private let systemImageName: String
    private let urlString: String

    /// Create a new `ExternalLinkElement`.
    /// - Parameters:
    ///   - title: displayed title (AttributedString)
    ///   - systemImageName: SF Symbol name to use as leading icon
    ///   - urlString: destination URL string
    init(title: LocalizedStringKey, systemImageName: String, urlString: String) {
        self.title = title
        self.systemImageName = systemImageName
        self.urlString = urlString
    }

    var body: some View {
        Button(action: openURL, label: {
            HStack {
                Image(systemName: systemImageName)
                Text(title)
                Spacer()
                Image(systemName: .systemImage.arrowUp.name)
                    .foregroundStyle(.gray)
            }
            .foregroundStyle(.foreground)
        })
        .accessibilityIdentifier("settings_externalLink_\(id)")
        .accessibilityLabel(Text(title))
    }

    /// Open the provided URL using a platform appropriate API.
    private func openURL() {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - SubmenuElement

/// A navigation row that presents a destination view when selected.
///
/// The `SubmenuElement` renders a leading SF Symbol and a title and pushes the
/// provided `destination` when tapped. The destination is supplied as a
/// builder closure to avoid eager construction at initialization time.
private struct SubmenuElement<Destination: View>: View, Identifiable {
    let id = UUID()
    private let title: LocalizedStringKey
    private let systemImageName: String
    @ViewBuilder private let destinationBuilder: () -> Destination

    /// Create a submenu row.
    /// - Parameters:
    ///   - title: title to display
    ///   - systemImageName: SF Symbol name
    ///   - destination: builder closure that returns the destination view
    init(title: LocalizedStringKey,
         systemImageName: String,
         @ViewBuilder destination: @escaping () -> Destination)
    {
        self.title = title
        self.systemImageName = systemImageName
        self.destinationBuilder = destination
    }

    var body: some View {
        NavigationLink(destination: destinationBuilder()) {
            HStack {
                Image(systemName: systemImageName)
                Text(title)
            }
            .foregroundStyle(.foreground)
        }
        .accessibilityIdentifier("settings_submenu_\(id)")
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let softwareComponentsTitle: Self = "Software Components"
    static let dataComponentsTitle: Self = "Data Components"
    static let developerAppsTitle: Self = "Developer Apps"
    static let sendLogTitle: Self = "Send Log"
    static let deleteDataButtonTitle: Self = "Delete Data"
    static let rateAppTitle: Self = "Rate App"
    static let sendFeedbackTitle: Self = "Send Feedback"
    static let privacyTitle: Self = "Privacy"
    static let developmentTitle: Self = "Development"
    static let iCloudSyncingTitle: Self = "iCloud Syncing"
    static let analyticsTitle: Self = "Send Analytics"
}

private extension Text {
    static let navigationBarTitle: Self = .init("Settings")
}

// MARK: - Preview

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewDisplayName("Settings")
            .previewLayout(.sizeThatFits)
    }
}
#endif
