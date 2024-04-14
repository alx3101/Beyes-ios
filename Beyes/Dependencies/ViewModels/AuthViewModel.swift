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
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var country: String = ""
    @Published var dateOfBirth: String = ""

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
}
