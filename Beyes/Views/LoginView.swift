//
//  LoginView.swift
//  Beyes
//
//  Created by Alex Popa on 13/04/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var router: Router
    @Environment(\.appEnvironment) var appEnvironment
    @State private var action: Loadable<Void> = .notRequested
    @State private var email: String = ""
    @State private var emailError: String? = nil
    @State private var password: String = ""
    @State private var passwordError: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 150)

            CustomTextField(text: $email,
                            error: $emailError,
                            topTitle: "E-mail",
                            placeholder: "Your e-mail")

            Spacer()
                .frame(height: 16)

            CustomSecureField(text: $password,
                              error: $passwordError,
                              topTitle: "Password",
                              placeholder: "Your password")

            Spacer()
                .frame(height: 16)

            if let error = action.hasError {
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
            }

            Button("Sign in") {
                login()
            }
            .padding(.vertical, 10)
            .buttonStyle(Primary(type: .regular))

            HStack {
                Button(action: {}, label: {
                    Text("Dimenticato la password?")
                        .font(.system(size: 12))
                        .padding(.leading, 8)
                })

                Spacer()
            }

            Spacer()

            HStack(spacing: 4) {
                Text("Non hai un account?")
                Text("Registrati")
                    .foregroundStyle(Asset.Colors.primary.swiftUIColor)
            }
            .font(.system(size: 15))
            .onTapGesture {
                router.navigateTo(.registration)
            }

            Spacer().frame(height: 50)
        }
        .padding(.horizontal, 16)
        .overlay {
            if action.isLoading {
                LoadingView()
            } else if let error = action.hasError {
                Text(error.localizedDescription)
            }
        }
    }
}

private extension LoginView {
    func login() {
        guard checkFields() else {
            return
        }

        appEnvironment.interactors.auth.signIn(email: email, password: password) { action = $0 }
        router.setMain(.home)
    }

    func checkFields() -> Bool {
        guard !email.isEmpty else {
            emailError = AuthError.empty(Field.email).localizedDescription
            return false
        }

        guard !password.isEmpty else {
            passwordError = AuthError.empty(Field.password).localizedDescription
            return false
        }

        return true
    }
}

#Preview {
    LoginView()
        .environmentObject(Router(rootViewContent: .init(AppRoute.login.view())))
}
