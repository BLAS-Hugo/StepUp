//
//  AuthenticationService.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthenticationService: ObservableObject {
    @Published var currentUserSession: FirebaseAuth.User?
    @Published var currentUser: User?

    var listener: AuthStateDidChangeListenerHandle?

    init() {
        currentUserSession = Auth.auth().currentUser
        Task {
            await fetchUserData()
        }
    }

    func signUp(email: String, password: String, firstName: String, name: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.currentUserSession = result.user

            let user = User(id: result.user.uid, email: email, name: name, firstName: firstName)
            try await addUserToDB(user: user)
            await fetchUserData()
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }

    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.currentUserSession = result.user
            await fetchUserData()
        } catch {
            print("Could not sign user in (error: \(error.localizedDescription))")
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUserSession = nil
            currentUser = nil
        } catch {
            print("Could not sign user out (error: \(error.localizedDescription))")
        }
    }

    func deleteAccount() {
        currentUserSession = nil
        currentUser = nil
    }

    func fetchUserData() async {
        guard let uid = currentUserSession?.uid else { return }

        guard let document = try? await Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument()
        else { return }
        self.currentUser = try? document.data(as: User.self)
    }

    private func addUserToDB(user: User) async throws {
        let encodedUser = try Firestore.Encoder().encode(user)
        try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
    }
}
