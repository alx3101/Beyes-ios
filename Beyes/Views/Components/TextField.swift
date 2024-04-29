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
    @Binding var error: Error?
    let topTitle: String?
    let placeholder: String

    init(text: Binding<String>,
         error: Binding<Error?> = .constant(nil),
         topTitle: String? = nil,
         placeholder: String) {
        _text = text
        _error = error
        self.topTitle = topTitle
        self.placeholder = placeholder
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let topTitle {
                Text(topTitle)
                    .padding(.leading, 4)
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
            }
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(error != nil ? Color.red.opacity(0.1) : .white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(error != nil ? Color.red : .gray.opacity(0.25), lineWidth: 0.5)
                        )
                }
        }
    }
}

struct CustomSecureField: View {
    @State private var passwordHidden: Bool = true
    @Binding var text: String
    @Binding var error: Error?
    let topTitle: String?
    let placeholder: String

    init(text: Binding<String>,
         error: Binding<Error?> = .constant(nil),
         topTitle: String? = nil,
         placeholder: String) {
        _text = text
        _error = error
        self.topTitle = topTitle
        self.placeholder = placeholder
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let topTitle {
                Text(topTitle)
                    .padding(.leading, 4)
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
            }

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
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(error != nil ? Color.red.opacity(0.1) : .white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(error != nil ? Color.red : .gray.opacity(0.25), lineWidth: 0.5)
                    )
            }
        }
    }
}

#Preview {
    VStack {
        CustomTextField(text: .constant("test"), topTitle: "Top", placeholder: "")
        CustomSecureField(text: .constant("test"), topTitle: "Top", placeholder: "")
    }
}
