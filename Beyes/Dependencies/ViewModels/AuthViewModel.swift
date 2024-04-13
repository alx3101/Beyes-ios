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
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
}

class AuthViewModel: AuthViewModelProvider, ObservableObject {
    @Published var currentSession: Bool?
    @Published var email: String = ""
    @Published var password: String = ""

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
        action(.notRequested)
        Task {
            do {
                try await service.signIn(email: email, password: password)
                action(.loaded(voidReturn))
            } catch {
                action(.failed(error))
            }
        }
    }

    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await service.logout()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
