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

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 150)

            CustomTextField(text: appEnvironment.viewModels.$authentication.email,
                            topTitle: "E-mail",
                            placeholder: "Your e-mail")

            Spacer()
                .frame(height: 16)

            CustomSecureField(text: appEnvironment.viewModels.$authentication.password, placeholder: "Your password")

            Spacer()
                .frame(height: 16)

            Button("Sign in") {
                login()
            }
            .padding(.vertical, 10)
            .buttonStyle(Primary(type: .pill))

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
        .navigationBarBackButtonHidden()
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
        appEnvironment.viewModels.authentication.signIn { action = $0 }
    }
}

#Preview {
    LoginView()
}
