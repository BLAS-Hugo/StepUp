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
    var currentUserSession: AppAuthUserProtocol? { get set }
    var currentUser: User? { get set }

    func signUp(email: String, password: String, firstName: String, name: String) async throws
    func signIn(withEmail email: String, password: String) async throws
    func signOut()
    func deleteAccount() async throws
    func fetchUserData() async
    func updateUserData(name: String, firstName: String) async throws
}
