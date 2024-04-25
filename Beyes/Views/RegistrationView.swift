//
//  RegistrationView.swift
//  Beyes
//
//  Created by Alex Popa on 14/04/24.
//

import FlagKit
import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var router: Router
    @Environment(\.appEnvironment) var appEnvironment

    @State private var action: Loadable<Void> = .notRequested
    var isButtonDisabled: Bool { !appEnvironment.viewModels.authentication.termsChecked || !appEnvironment.viewModels.authentication.privacyChecked }

    var body: some View {
        ScrollView {
            VStack(spacing: 4) {
                VStack(spacing: 8) {
                    Spacer()
                        .frame(height: 25)

                    CustomTextField(text: appEnvironment.viewModels.$authentication.fullName,
                                    topTitle: "Full name",
                                    placeholder: "Full name")

                    CustomTextField(text: appEnvironment.viewModels.$authentication.dateOfBirth,
                                    topTitle: "Date of birth",
                                    placeholder: "Date of birth")

                    CustomPicker(topTitle: "Nation", selection: appEnvironment.viewModels.$authentication.selectedCountry, items: {
                        appEnvironment.viewModels.authentication.countries
                    }, placeholder: "Select your country") { item in
                        Text(item.name)
                    } getImageView: { item in
                        if let imageName = item.image, let image = UIImage(named: imageName) {
                            return AnyView(Image(uiImage: image))
                        } else {
                            return AnyView(Image(systemName: "photo"))
                        }
                    }
                    .zIndex(1)

                    CustomTextField(text: appEnvironment.viewModels.$authentication.email,
                                    topTitle: "E-mail",
                                    placeholder: "E-mail")

                    CustomSecureField(text: appEnvironment.viewModels.$authentication.password,
                                      topTitle: "Password",
                                      placeholder: "Password")

                    CustomSecureField(text: appEnvironment.viewModels.$authentication.confirmedPassword,
                                      topTitle: "Confirm password",
                                      placeholder: "Confirm password")

                    Spacer()
                        .frame(height: 16)

                    checkStack

                    Button("Sign in") {
                        print("Button pressed!")
                    }
                    .padding(.vertical, 20)
                    .buttonStyle(Primary(type: .regular))
                    .disabled(isButtonDisabled)
                    .opacity(isButtonDisabled ? 0.5 : 1)

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
    }
}

private extension RegistrationView {
    var checkStack: some View {
        VStack {
            Toggle(isOn: appEnvironment.viewModels.$authentication.termsChecked) {
                HStack(spacing: 4) {
                    Text("Accept")
                        .foregroundStyle(.black)
                        .font(.system(size: 16))

                    Text("terms and conditions")
                        .foregroundStyle(.blue)
                        .font(.system(size: 16))
                }
                .onTapGesture {}
            }
            .toggleStyle(CheckboxToggleStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 5)

            Toggle(isOn: appEnvironment.viewModels.$authentication.privacyChecked) {
                HStack(spacing: 4) {
                    Text("Accept")
                        .foregroundStyle(.black)
                        .font(.system(size: 16))

                    Text("privacy policy")
                        .foregroundStyle(.blue)
                        .font(.system(size: 16))
                }
                .onTapGesture {}
            }
            .toggleStyle(CheckboxToggleStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 5)
        }
    }
}

private extension RegistrationView {
    func signIn() {
        appEnvironment.viewModels.authentication.signUp { action = $0 }
    }

    func pop() {
        appEnvironment.viewModels.authentication.clearFields()
        router.navigateBack()
    }
}

#Preview {
    RegistrationView()
}
