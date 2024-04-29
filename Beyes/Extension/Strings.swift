//
//  Strings.swift
//  Beyes
//
//  Created by Alex Popa on 29/04/24.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        // Regex pattern per verificare il formato dell'email
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        // Crea un predicato con il pattern regex
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        // Verifica se la stringa corrisponde al pattern regex
        return emailPredicate.evaluate(with: self)
    }

    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}
