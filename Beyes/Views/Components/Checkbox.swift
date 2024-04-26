//
//  Checkbox.swift
//  Beyes
//
//  Created by Alex Popa on 26/04/24.
//

import Foundation
import SwiftUI

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(configuration.isOn ? Color.accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview(body: {
    VStack {
        Toggle(isOn: .constant(false)) {
            HStack {
                Text("Buy a pack of Airtags")
                Spacer()
            }
        }
        .toggleStyle(CheckToggleStyle())
        .frame(maxWidth: .infinity)
    }
})
