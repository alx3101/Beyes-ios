//
//  AuthViewModel.swift
//  Beyes
//
//  Created by Alex Popa on 12/04/24.
//

import Combine
import Foundation
import SwiftUI

protocol AuthViewModelProvider {
    var currentSession: Bool? { get }
    func signIn(action: @escaping (Loadable<Void>) -> Void)
    func signUp(action: @escaping (Loadable<Void>) -> Void)
    func logout(action: @escaping (Loadable<Void>) -> Void)
}

class AuthViewModel: AuthViewModelProvider, ObservableObject {
    @Published var currentSession: Bool?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmedPassword: String = ""
    @Published var fullName: String = ""
    @Published var country: String = ""
    @Published var dateOfBirth: String = ""
    @Published var selectedCountry: Country? = nil
    @Published var isPickerVisible = false
    @Published var termsChecked = false
    @Published var privacyChecked = false
    var countries: [Country] {
        let current = Locale.current.region?.identifier

        let locales = Locale.Region.isoRegions
            .compactMap { Country(id: $0.identifier, name: Locale.current.localizedString(forRegionCode: $0.identifier) ?? "", image: $0.identifier)
            }

        let currentCountry: Country = .init(id: current ?? "", name: Locale.current.localizedString(forRegionCode: current ?? "") ?? "", image: current ?? "")

        return [currentCountry] + locales
    }

    private let service: AuthServices
    var cancellables = Set<AnyCancellable>()

    init(authServices: AuthServices) {
        service = authServices
        service.sessionSubjectPublisher
            .receive(on: DispatchQueue.main)
            .first(where: { $0 != nil })
            .first()
            .sink { [weak self] session in
                self?.currentSession = session
            }
            .store(in: &cancellables)
    }

    func signIn(action: @escaping (Loadable<Void>) -> Void) {
        action(.loading)
        Task {
            do {
                try await service.signIn(email: email, password: password)
                action(.loaded(voidReturn))
            } catch {
                action(.failed(error))
            }
        }
    }

    func signUp(action: @escaping (Loadable<Void>) -> Void) {
        action(.loading)
        Task {
            do {
                if let error = emptyFields() {
                    action(.failed(error))
                }

                try await service.signUp(email: email, password: password)
            } catch {
                action(.failed(error))
            }
        }
    }

    func logout(action: @escaping (Loadable<Void>) -> Void) {
        Task {
            do {
                try await service.logout()
                action(.loaded(voidReturn))
            } catch {
                action(.failed(error))
            }
        }
    }

    private func emptyFields() -> Error? {
        guard email.isEmpty else {
            return AuthViewModelError.empty(Field.email)
        }

        guard password.isEmpty else {
            return AuthViewModelError.empty(Field.password)
        }

        guard confirmedPassword.isEmpty else {
            return AuthViewModelError.empty(Field.confirmPassword)
        }

        guard password == confirmedPassword else {
            return AuthViewModelError.passwordNotMatch
        }

        guard fullName.isEmpty else {
            return AuthViewModelError.empty(Field.fullName)
        }

        guard country.isEmpty else {
            return AuthViewModelError.empty(Field.country)
        }

        guard dateOfBirth.isEmpty else {
            return AuthViewModelError.empty(Field.dateOfBirth)
        }

        return nil
    }

    func clearFields() {
        email = ""
        password = ""
        confirmedPassword = ""
        fullName = ""
        country = ""
        dateOfBirth = ""
    }
}

enum Field {
    case email
    case password
    case confirmPassword
    case fullName
    case country
    case dateOfBirth

    var value: String {
        switch self {
        case .email:
            "Email"
        case .password:
            "Password"
        case .confirmPassword:
            "Conferma password"
        case .fullName:
            "Nome e cognome"
        case .country:
            "Nazionalità"
        case .dateOfBirth:
            "Data di nascita"
        }
    }
}

enum AuthViewModelError: Error {
    case empty(Field)
    case invalid(Field)
    case passwordNotMatch
    case unknown

    var localizedDescription: String {
        switch self {
        case let .empty(field):
            return NSLocalizedString("Il campo \(field.value) non può essere vuoto.", comment: "")
        case let .invalid(field):
            return NSLocalizedString("Il campo \(field.value) non è valido.", comment: "")
        case .passwordNotMatch:
            return NSLocalizedString("Le password non coincidono", comment: "")

        case .unknown:
            return NSLocalizedString("Si è verificato un errore sconosciuto.", comment: "")
        }
    }
}
