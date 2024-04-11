//
//  Settings.swift
//  Beyes
//
//  Created by Alex Popa on 30/03/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 8) {
            ForEach(Setting.allCases, id: \.self) {
                if $0 == .logout {
                    Spacer()
                }
                generateCell($0)
            }
        }
        .padding(.horizontal, 16)
    }
}

private extension SettingsView {
    enum Setting: CaseIterable {
        case profile
        case info
        case privacy
        case terms
        case notification
        case logout

        var title: String {
            switch self {
            case .profile:
                "Profilo"
            case .info:
                "Info"
            case .privacy:
                "Privacy"
            case .terms:
                "Terms"
            case .notification:
                "Notification"
            case .logout:
                "Logout"
            }
        }
    }

    func generateCell(_ setting: Setting) -> some View {
        HStack {
            if setting == .logout {
                Spacer()
            }

            Text(setting.title)
            Spacer()

            if setting != .logout {
                Image(systemName: "chevron.right")
            }
        }
        .padding(8)
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: setting != .logout ? 10 : 20)
                .fill(setting != .logout ? .blur : Color.red)
        }
    }
}

#Preview {
    SettingsView()
}
