//
//  Buttons.swift
//  Beyes
//
//  Created by Alex Popa on 13/04/24.
//

import Foundation
import SwiftUI

enum ButtonStyleType {
    case small
    case regular
    case pill

    var height: CGFloat {
        switch self {
        case .regular:
            48.0
        case .small:
            32.0
        case .pill:
            36.0
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .regular:
            16
        case .small:
            16
        case .pill:
            14
        }
    }
}

struct Primary: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled: Bool
    let type: ButtonStyleType

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: type.height)
            .frame(height: type.height)
            .background(Asset.Colors.primary.swiftUIColor)
            .contentShape(Rectangle())
            .cornerRadius(200)
            .font(.system(size: type.fontSize))
    }
}

struct Secondary: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled: Bool
    let type: ButtonStyleType
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: type.height)
            .frame(height: type.height)
            .background(Asset.Colors.secondary.swiftUIColor)
            .contentShape(Rectangle())
            .cornerRadius(200)
            .font(.system(size: type.fontSize))
    }
}

struct Tertiary: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled: Bool
    let type: ButtonStyleType
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: type.height)
            .frame(height: type.height)
            .background(Asset.Colors.tertiary.swiftUIColor)
            .contentShape(Rectangle())
            .cornerRadius(200)
            .font(.system(size: type.fontSize))
    }
}

struct Destructive: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled: Bool
    let type: ButtonStyleType

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: type.height)
            .frame(height: type.height)
            .background(.blue)
            .contentShape(Rectangle())
            .cornerRadius(200)
            .font(.system(size: type.fontSize))
            .foregroundStyle(.threateningRed)
    }
}

struct Clear: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16))
            .modifier(ClearModifier())
    }
}

struct ClearModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(.clear)
    }
}
