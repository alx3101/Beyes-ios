//
//  AuthViewModel.swift
//  Beyes
//
//  Created by Alex Popa on 12/04/24.
//

import Foundation

protocol AuthViewModelProvider {
    func signIn(email: String, password: String)
}

class AuthViewModel: AuthViewModelProvider {
    func signIn(email _: String, password _: String) {}
}
