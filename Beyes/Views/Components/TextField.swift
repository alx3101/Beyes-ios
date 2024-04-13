//
//  TextField.swift
//  Beyes
//
//  Created by Alex Popa on 13/04/24.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String

    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .font(.system(size: 16))

            Spacer()
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.regularMaterial)
        }
    }
}

struct CustomSecureField: View {
    @Binding var text: String
    @State private var passwordHidden: Bool = true
    let placeholder: String

    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    var body: some View {
        HStack {
            if passwordHidden {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 16))

            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
            }

            Spacer()

            Button { passwordHidden.toggle() } label: {
                Image(systemName: passwordHidden ? "eye" : "eye.slash")
                    .renderingMode(.template)
                    .tint(.gray)
            }
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.regularMaterial)
        }
    }
}

#Preview {
    CustomSecureField(text: .constant(""), placeholder: "")
}
