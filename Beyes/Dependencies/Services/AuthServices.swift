//
//  AuthServices.swift
//  Beyes
//
//  Created by Alex Popa on 12/04/24.
//

import Combine
import Foundation
import Supabase
import SwiftyBeaver

protocol AuthProtocol {
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws
    func logout() async throws
    func resetPassword(email: String) async throws
    func refreshSession() async throws
}

class AuthServices: AuthProtocol {
    private let client: SupabaseClient
    private var sessionSubject = CurrentValueSubject<Bool?, Never>(nil)

    var sessionSubjectPublisher: AnyPublisher<Bool?, Never> {
        return sessionSubject.eraseToAnyPublisher()
    }

    init(client: SupabaseClient) {
        self.client = client
        currentSession()
    }

    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(
            email: email,
            password: password
        )
    }

    func signUp(email: String, password: String) async throws {
        try await client.auth.signUp(
            email: email,
            password: password
        )
    }

    private func currentSession() {
        Task {
            for await state in await client.auth.authStateChanges {
                if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                    sessionSubject.send(state.session != nil)
                    SwiftyBeaver.debug("State session: \(state.session != nil)")
                } else {
                    sessionSubject.send(state.session != nil)
                }
            }
        }
    }

    func logout() async throws {
        _ = try await client.auth.signOut()
    }

    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
    }

    func refreshSession() async throws {
        _ = try await client.auth.session
    }
}
