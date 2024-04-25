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
    @State private var selectedCountry: Country? = nil
    @State private var isPickerVisible = false
    @State private var termsChecked = false
    @State private var privacyChecked = false
    var isButtonDisabled: Bool { !termsChecked || !privacyChecked }

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
            Toggle(isOn: $termsChecked) {
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
            
            Toggle(isOn: $privacyChecked) {
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

    var countries: [Country] {
        let current = Locale.current.region?.identifier

        let locales = Locale.Region.isoRegions
            .compactMap { Country(id: $0.identifier, name: Locale.current.localizedString(forRegionCode: $0.identifier) ?? "", image: $0.identifier)
            }

        let currentCountry: Country = .init(id: current ?? "", name: Locale.current.localizedString(forRegionCode: current ?? "") ?? "", image: current ?? "")

        return [currentCountry] + locales
    }
}

private struct Country: Hashable, Equatable, Identifiable {
    var id: String
    var name: String
    var image: String?
}

#Preview {
    RegistrationView()
}
