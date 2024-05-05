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
    func signUp(email: String, password: String, fullName: String, dateOfBirth: String, country: String, termsChecked: Bool, privacyChecked: Bool) async throws
    func logout() async throws
    func deleteAccount(id: String) async throws
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

    func signUp(email: String, password: String, fullName: String, dateOfBirth: String, country: String, termsChecked: Bool, privacyChecked: Bool) async throws {
        let signUp = try await client.auth.signUp(
            email: email,
            password: password,
            data: [
                "full_name": .string(fullName),
                "date_of_birth": .string(dateOfBirth),
                "country": .string(country), // Assicurati che `selectedCountry` non sia nil
                "terms_checked": .bool(termsChecked),
                "privacy_checked": .bool(privacyChecked)
            ]
        )

        let post = try await client.database
            .schema("public")
            .from("users_email")
            .insert(["email": signUp.session?.user.email])
            .execute()
        print("Informazioni utente inserite nel database.")
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

    func checkUserExists(email: String) async throws -> Bool? {
        do {
            // Execute a query to check if the user exists in the database
            let response = try await client.database
                .schema("public")
                .from("users_email")
                .select("email")
                .eq("email", value: email) // Confronta direttamente il valore della colonna email con l'email fornita
                .execute()

            // Check if the query returns any results
            return !response.data.isEmpty
        } catch {
            // If there was an error during the query execution, handle it here
            print("Error during query execution:", error.localizedDescription)
            return nil
        }
    }

    func deleteAccount(id: String) async throws {
        _ = try await client.auth.admin.deleteUser(id: id)
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
