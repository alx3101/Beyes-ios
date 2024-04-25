//
//  Checkbox.swift
//  Beyes
//
//  Created by Alex Popa on 26/04/24.
//

import Foundation
import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(lineWidth: 2)
                .frame(width: 25, height: 25)
                .cornerRadius(5.0)
                .overlay {
                    withAnimation {
                        Image(systemName: configuration.isOn ? "checkmark" : "")
                    }
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
                .padding(.trailing, 15)

            configuration.label
        }
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
        .toggleStyle(CheckboxToggleStyle())
        .frame(maxWidth: .infinity)
    }
})
