//
//  AuthInteractor.swift
//  Beyes
//
//  Created by Alex Popa on 12/04/24.
//

import Combine
import Foundation
import SwiftUI

protocol AuthVInteractorProvider {
    var currentSession: Bool? { get }
    func signIn(email: String, password: String, action: @escaping (Loadable<Void>) -> Void)
    func signUp(email: String, password: String, action: @escaping (Loadable<Void>) -> Void)
    func logout(action: @escaping (Loadable<Void>) -> Void)
    func resetPassword(email: String, action: @escaping (Loadable<Void>) -> Void)
}

class AuthInteractor: AuthVInteractorProvider, ObservableObject {
    @Published var currentSession: Bool?

    private let service: AuthServices
    var cancellables = Set<AnyCancellable>()

    init(authServices: AuthServices) {
        service = authServices
        service.sessionSubjectPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] session in
                self?.currentSession = session
            }
            .store(in: &cancellables)
    }

    func signIn(email: String, password: String, action: @escaping (Loadable<Void>) -> Void) {
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

    func signUp(email: String, password: String, action: @escaping (Loadable<Void>) -> Void) {
        action(.loading)
        Task {
            do {
                try await service.signUp(email: email, password: password)
                action(.loaded(voidReturn))
            } catch {
                action(.failed(error))
            }
        }
    }

    func resetPassword(email: String, action: @escaping (Loadable<Void>) -> Void) {
        action(.loading)
        Task {
            do {
                guard let userExist = try await service.checkUserExists(email: email) else {
                    return action(.failed(AuthError.unknown))
                }
                if userExist {
                    try await service.resetPassword(email: email)
                    action(.loaded(voidReturn))
                } else {
                    action(.failed(AuthError.userNotExist))
                }

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

enum AuthError: Error {
    case empty(Field)
    case invalid(Field)
    case passwordNotMatch
    case userNotExist
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
        case .userNotExist:
            return NSLocalizedString("User does not exist. Please verify the provided information.", comment: "")
        }
    }
}
