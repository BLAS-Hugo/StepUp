//
//  LoginViewController.swift
//  StepUp
//
//  Created by Hugo Blas on 14/03/2025.
//

import Foundation
import SwiftUI

struct LoginViewController {
    private let authService = AuthenticationService()

    func registerUser(email: String, password: String, onInvalidPassword: () -> Void, onInvalidEmail: () -> Void) async {
        if !validateEmail(email) {
            print("Invalid email format")
            // display alert to user
            onInvalidEmail()
            return
        }
        if !validatePassword(password) {
            print("Invalid password format")
            // display alert to user
            onInvalidPassword()
            return
        }

        do {
            try await authService.signUp(email: email, password: password)
        } catch {
            print("Could not register user")
            print("Error: \(error.localizedDescription)")
        }
    }

    func login(email: String, password: String, onInvalidPassword: () -> Void, onInvalidEmail: () -> Void) {
        if !validateEmail(email) {
            print("Invalid email format")
            // display alert to user
            onInvalidEmail()
            return
        }
        if !validatePassword(password) {
            print("Invalid password format")
            // display alert to user
            onInvalidPassword()
            return
        }

        authService.signIn(email: email, password: password)
    }

    private func validateEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    private func validatePassword(_ string: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: string)
    }

    private func isFormValid(email: String, password: String) -> Bool {
        return !email.isEmpty && validateEmail(email) && !password.isEmpty && validatePassword(password)
    }
}
