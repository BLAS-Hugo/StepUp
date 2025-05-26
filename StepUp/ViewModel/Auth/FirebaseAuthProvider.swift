//
//  FirebaseAuthProvider.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

enum AuthError: Error {
    case requiresRecentLogin
    case unknown // For other errors
    case noAuthenticatedUser
    case noCurrentUserData
}

@MainActor
class FirebaseAuthProvider: AuthProviding {
    @Published var currentUserSession: AppAuthUserProtocol? {
        didSet {
            // Automatically fetch user data when session changes
            if currentUserSession != nil {
                Task {
                    await fetchUserData()
                }
            } else {
                currentUser = nil
            }
        }
    }
    @Published var currentUser: User?

    private let database = Firestore.firestore()
    private var usersCollection: CollectionReference {
        database.collection("users")
    }
    private var auth: Auth {
        Auth.auth()
    }

    init() {
        self.currentUserSession = Auth.auth().currentUser
    }

    func signUp(email: String, password: String, firstName: String, name: String) async throws {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            self.currentUserSession = result.user

            let user = User(id: result.user.uid, email: email, name: name, firstName: firstName)
            try addUserToDB(user: user)
            await fetchUserData()
        } catch {
            throw error
        }
    }

    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            self.currentUserSession = result.user
            await fetchUserData()
        } catch {
            throw error
        }
    }

    func signOut() {
        do {
            try auth.signOut()
        } catch {
            print("Could not sign user out (error: \(error.localizedDescription))")
        }
        currentUserSession = nil
        currentUser = nil
    }

    func deleteAccount() async throws {
        guard let firebaseUserToDelete = auth.currentUser else {
            if self.currentUserSession != nil || self.currentUser != nil {
                self.currentUserSession = nil
                self.currentUser = nil
            }
            return
        }

        let userIdToDelete = firebaseUserToDelete.uid

        do {
            try await firebaseUserToDelete.delete()
            try await usersCollection.document(userIdToDelete).delete()
        } catch let error as NSError {
            if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                throw AuthError.requiresRecentLogin
            } else {
                throw AuthError.unknown
            }
        }
        self.currentUserSession = nil
        self.currentUser = nil
    }

    func fetchUserData() async {
        guard let uid = currentUserSession?.uid else {
            if currentUser != nil {
                currentUser = nil
            }
            return
        }

        do {
            let document = try await usersCollection.document(uid).getDocument()
            self.currentUser = try document.data(as: User.self)
        } catch {
            if currentUser != nil {
                currentUser = nil
            }
        }
    }

    private func addUserToDB(user: User) throws {
        try usersCollection.document(user.id).setData(from: user)
    }

    func updateUserData(name: String, firstName: String) async throws {
        guard currentUserSession != nil else {
            throw AuthError.noAuthenticatedUser
        }

        guard let strongCurrentUser = currentUser else {
            throw AuthError.noCurrentUserData
        }

        let updatedUser = User(
            id: strongCurrentUser.id,
            email: strongCurrentUser.email,
            name: name,
            firstName: firstName
        )

        try usersCollection.document(strongCurrentUser.id).setData(from: updatedUser)
        await fetchUserData()
    }

    // Public method to update the current user session (used by AuthenticationViewModel)
    func updateUserSession(_ user: FirebaseAuth.User?) {
        self.currentUserSession = user
    }
}
