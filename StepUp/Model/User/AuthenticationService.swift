//
//  AuthenticationService.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AuthenticationService {
    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }

    func signIn(email: String, password: String)  {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let authResult = authResult {
                print("User signed in successfully: \(authResult.user)")
            }
          }
    }

    func signOut()  {
        try!  Auth.auth().signOut()
    }
}
