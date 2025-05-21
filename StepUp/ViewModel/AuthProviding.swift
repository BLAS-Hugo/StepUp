//
//  AuthProviding.swift
//  StepUp
//
//  Created by Hugo Blas on 19/05/2025.
//

import Foundation
import FirebaseAuth

@MainActor
protocol AuthProviding: ObservableObject {
    var currentUserSession: AppAuthUserProtocol? { get }
    var currentUser: User? { get }

    func signUp(email: String, password: String, firstName: String, name: String) async throws
    func signIn(withEmail email: String, password: String) async throws
    func signOut()
    func deleteAccount() async throws
    func fetchUserData() async // This might become an internal detail or a more specific public API
}
