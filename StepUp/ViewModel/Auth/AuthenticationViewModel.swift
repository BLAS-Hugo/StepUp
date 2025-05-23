//
//  AuthenticationViewModel.swift
//  StepUp
//
//  Created by Assistant on 23/05/2025.
//

import Foundation
import Combine

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false

    private let authProvider: any AuthProviding

    var currentUserEmail: String? {
        authProvider.currentUserSession?.email
    }

    init(authProvider: any AuthProviding) {
        self.authProvider = authProvider
        updateAuthenticationState()
    }

    func updateAuthenticationState() {
        currentUser = authProvider.currentUser
        isAuthenticated = authProvider.currentUserSession != nil && authProvider.currentUser != nil
    }

    func signUp(email: String, password: String, firstName: String, name: String) async throws {
        try await authProvider.signUp(email: email, password: password, firstName: firstName, name: name)
        updateAuthenticationState()
    }

    func signIn(email: String, password: String) async throws {
        try await authProvider.signIn(withEmail: email, password: password)
        updateAuthenticationState()
    }

    func signOut() {
        authProvider.signOut()
        updateAuthenticationState()
    }

    func deleteAccount() async throws {
        try await authProvider.deleteAccount()
        updateAuthenticationState()
    }

    func updateUserData(name: String, firstName: String) async throws {
        try await authProvider.updateUserData(name: name, firstName: firstName)
        updateAuthenticationState()
    }

    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    func validateName(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
