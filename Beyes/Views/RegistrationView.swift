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
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmedPassword: String = ""
    @State private var fullName: String = ""
    @State private var dateOfBirth: String = ""
    @State private var selectedCountry: Country? = nil
    @State private var isPickerVisible = false
    @State private var termsChecked = false
    @State private var privacyChecked = false

    // MARK: Errors

    @State private var emailError: Error? = nil
    @State private var passwordError: Error? = nil
    @State private var confirmPasswordError: Error? = nil
    @State private var fullNameError: Error? = nil
    @State private var countryError: Error? = nil
    @State private var dateOfBirthError: Error? = nil

    var isButtonDisabled: Bool { !termsChecked || !privacyChecked }

    var body: some View {
        ScrollView {
            VStack(spacing: 4) {
                VStack(spacing: 8) {
                    Spacer()
                        .frame(height: 25)

                    CustomTextField(text: $fullName,
                                    error: $fullNameError,
                                    topTitle: "Full name",
                                    placeholder: "Full name")

                    CustomTextField(text: $dateOfBirth,
                                    error: $dateOfBirthError,
                                    topTitle: "Date of birth",
                                    placeholder: "Date of birth")

                    CustomPicker(topTitle: "Nation", selection: $selectedCountry, items: {
                        countries
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

                    CustomTextField(text: $email,
                                    error: $emailError,
                                    topTitle: "E-mail",
                                    placeholder: "E-mail")

                    CustomSecureField(text: $password,
                                      error: $passwordError,
                                      topTitle: "Password",
                                      placeholder: "Password")

                    CustomSecureField(text: $confirmedPassword,
                                      error: $confirmPasswordError,
                                      topTitle: "Confirm password",
                                      placeholder: "Confirm password")

                    Spacer()
                        .frame(height: 16)

                    checkStack

                    Button("Sign in") {
                        signIn()
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
            Toggle(isOn: $termsChecked) {
                HStack(spacing: 4) {
                    Text("Accept")
                        .foregroundStyle(.black)
                        .font(.system(size: 16))

                    Text("terms and conditions")
                        .foregroundStyle(.blue)
                        .font(.system(size: 16))
                }
            }
            .toggleStyle(CheckToggleStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 5)
            .id(UUID())

            Toggle(isOn: $privacyChecked) {
                HStack(spacing: 4) {
                    Text("Accept")
                        .foregroundStyle(.black)
                        .font(.system(size: 16))

                    Text("privacy policy")
                        .foregroundStyle(.blue)
                        .font(.system(size: 16))
                }
            }
            .toggleStyle(CheckToggleStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 5)
            .id(UUID())
        }
    }
}

private extension RegistrationView {
    func signIn() {
        guard checkFields() else {
            return
        }
        appEnvironment.interactors.auth.signUp(email: email, password: password) { action = $0
            if case .loaded = $0 {
                router.setMain(.home)
            }
        }
    }

    func pop() {
        router.navigateBack()
    }

    var countries: [Country] {
        let current = Locale.current.region?.identifier

        let locales = Locale.Region.isoRegions
            .compactMap { Country(id: $0.identifier, name: Locale.current.localizedString(forRegionCode: $0.identifier) ?? "", image: $0.identifier)
            }

        let currentCountry: Country = .init(id: current ?? "", name: Locale.current.localizedString(forRegionCode: current ?? "") ?? "", image: current ?? "")

        return [currentCountry] + locales
    }

    private func checkFields() -> Bool {
        guard !email.isEmpty else {
            emailError = AuthError.empty(Field.email)
            return false
        }

        guard !password.isEmpty else {
            passwordError = AuthError.empty(Field.password)
            return false
        }

        guard !confirmedPassword.isEmpty else {
            confirmPasswordError = AuthError.empty(Field.confirmPassword)
            return false
        }

        guard password == confirmedPassword else {
            confirmPasswordError = AuthError.invalid(Field.confirmPassword)
            return false
        }

        guard !fullName.isEmpty else {
            fullNameError = AuthError.empty(Field.fullName)
            return false
        }

        guard let selectedCountry else {
            countryError = AuthError.empty(Field.country)
            return false
        }

        guard !dateOfBirth.isEmpty else {
            dateOfBirthError = AuthError.empty(Field.dateOfBirth)
            return false
        }

        return true
    }
}

#Preview {
    RegistrationView()
}
