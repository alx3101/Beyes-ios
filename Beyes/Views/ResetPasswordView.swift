//
//  ResetPasswordView.swift
//  Beyes
//
//  Created by Alex Popa on 30/04/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var router: Router
    @Environment(\.appEnvironment) var appEnvironment
    @State private var action: Loadable<Void> = .notRequested

    @State private var email: String = ""
    @State private var emailError: String? = nil

    init(email: String) {
        _email = .init(initialValue: email)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer()
                .frame(height: 16)

            switch action {
            case .notRequested:
                notRequested
            case .loading:
                VStack {
                    Loader()
                }
                .frame(height: 250)
            case .loaded:
                requestCompleted
            default:
                notRequested
            }

            Spacer()
                .frame(height: 32)
        }
        .padding(.all, 16)
    }
}

private extension ResetPasswordView {
    @ViewBuilder
    var notRequested: some View {
        Text("Reset password")
            .semiBold(color: .black)

        Spacer()
            .frame(height: 8)

        Text("Per il reset della password, ti invieremo le istruzioni all'indirizzo e-mail specificato")
            .regular(size: 12, color: .gray)

        CustomTextField(text: $email,
                        error: $emailError,
                        placeholder: "Insert your e-mail")

        Spacer()
            .frame(height: 8)

        Button("Reset password") {
            resetPassword()
        }
        .buttonStyle(Primary(type: .pill))
    }

    @ViewBuilder
    var requestCompleted: some View {
        VStack {
            Text("Un'email di reset è stata inviata all'indirizzo \(email). Controlla la tua casella di posta e segui le istruzioni per reimpostare la password.")
                .regular(size: 12, color: .black)

            Spacer()
                .frame(height: 16)

            Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(.green)
        }
    }
}

private extension ResetPasswordView {
    func resetPassword() {
        withAnimation {
            guard !email.isEmpty else {
                emailError = AuthError.empty(.email).localizedDescription
                return
            }

            appEnvironment.interactors.auth.resetPassword(email: email) { action = $0

                if case let .failed(error) = $0 {
                    emailError = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    ResetPasswordView(email: "")
}
