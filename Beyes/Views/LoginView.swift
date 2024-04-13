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
        VStack {
            Spacer()
                .frame(height: 150)

            CustomTextField(text: appEnvironment.viewModels.$authentication.email, placeholder: "Your e-mail")

            Spacer()
                .frame(height: 16)

            CustomSecureField(text: appEnvironment.viewModels.$authentication.password, placeholder: "Your password")

            Button("Sign in") {
                print("Button pressed!")
            }
            .padding(.vertical, 10)
            .buttonStyle(Primary(type: .pill))

            Spacer()
        }
        .padding(.horizontal, 16)
        .overlay {
            if action.isLoading {
                LoadingView()
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
