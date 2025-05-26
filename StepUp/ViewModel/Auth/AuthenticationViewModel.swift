//
//  AuthenticationViewModel.swift
//  StepUp
//
//  Created by Hugo Blas on 26/05/2025.
//

import Foundation
import Combine
import FirebaseAuth

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var isInitialized: Bool = false

    private let authProvider: any AuthProviding
    private nonisolated(unsafe) var authStateListener: AuthStateDidChangeListenerHandle?

    var currentUserEmail: String? {
        authProvider.currentUserSession?.email
    }

    init(authProvider: any AuthProviding) {
        self.authProvider = authProvider
        setupAuthStateListener()
    }

    deinit {
        removeAuthStateListener()
    }

    private func setupAuthStateListener() {
        let listener = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            Task { @MainActor in
                guard let self = self else { return }

                if let firebaseAuthProvider = self.authProvider as? FirebaseAuthProvider {
                    firebaseAuthProvider.updateUserSession(user)
                    if user != nil {
                        await firebaseAuthProvider.fetchUserData()
                    }
                }

                self.updateAuthenticationState()
                    if !self.isInitialized {
                    self.isInitialized = true
                }
            }
        }
        authStateListener = listener
    }

    private nonisolated func removeAuthStateListener() {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
            authStateListener = nil
        }
    }

    func updateAuthenticationState() {
        currentUser = authProvider.currentUser
        isAuthenticated = authProvider.currentUserSession != nil && authProvider.currentUser != nil
    }

    func signUp(email: String, password: String, firstName: String, name: String) async throws {
        try await authProvider.signUp(email: email, password: password, firstName: firstName, name: name)
        updateAuthenticationState()
    }

    func signIn(withEmail email: String, password: String) async throws {
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

    func refreshAuthenticationState() async {
        await authProvider.fetchUserData()
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
