//
//  MockAuthProvider.swift
//  StepUpTests
//
//  Created by Hugo Blas on 16/05/2025.
//
import Foundation
import FirebaseAuth
@testable import StepUp

@MainActor
class MockAuthProvider: AuthProviding {
    @Published var currentUserSession: AppAuthUserProtocol?
    @Published var currentUser: StepUp.User?

    var signUpError: Error?
    var signInError: Error?
    var signOutError: Error?
    var deleteAccountError: Error?
    var fetchUserDataError: Error?
    var addUserToDBError: Error?
    var updateUserDataError: Error?

    var mockSignUpUserResult: AppAuthUserProtocol?
    var mockSignInUserResult: AppAuthUserProtocol?
    var mockFetchedUserData: StepUp.User?

    private(set) var signUpCalledCount = 0
    private(set) var signInCalledCount = 0
    private(set) var signOutCalledCount = 0
    private(set) var deleteAccountCalledCount = 0
    private(set) var fetchUserDataCalledCount = 0
    private(set) var addUserToDBCalledCount = 0
    private(set) var updateUserDataCalledCount = 0

    private(set) var lastSignUpEmail: String?
    private(set) var lastSignUpPassword: String?
    private(set) var lastSignUpFirstName: String?
    private(set) var lastSignUpName: String?
    private(set) var lastSignInEmail: String?
    private(set) var lastSignInPassword: String?
    private(set) var lastAddedUserToDB: StepUp.User?
    private(set) var lastUpdateUserDataName: String?
    private(set) var lastUpdateUserDataFirstName: String?

    init(currentUserSession: AppAuthUserProtocol? = nil, currentUser: StepUp.User? = nil) {
        self.currentUserSession = currentUserSession
        self.currentUser = currentUser
    }

    func signUp(email: String, password: String, firstName: String, name: String) async throws {
        signUpCalledCount += 1
        lastSignUpEmail = email
        lastSignUpPassword = password
        lastSignUpFirstName = firstName
        lastSignUpName = name

        if let error = signUpError { throw error }
        
        guard let mockUserSession = mockSignUpUserResult else {
            struct MockError: Error, LocalizedError { var errorDescription: String? = "MockAuthProvider.mockSignUpUserResult (AppAuthUserProtocol) not set for a successful sign up simulation." }; 
            throw MockError()
        }
        self.currentUserSession = mockUserSession
        
        addUserToDBCalledCount += 1
        let userForDB = StepUp.User(id: mockUserSession.uid, email: email, name: name, firstName: firstName)
        lastAddedUserToDB = userForDB
        if let error = addUserToDBError { throw error }
        
        self.currentUser = mockFetchedUserData ?? userForDB
    }

    func signIn(withEmail email: String, password: String) async throws {
        signInCalledCount += 1
        lastSignInEmail = email
        lastSignInPassword = password

        if let error = signInError { throw error }
        
        guard let mockUserSession = mockSignInUserResult else {
            struct MockError: Error, LocalizedError { var errorDescription: String? = "MockAuthProvider.mockSignInUserResult (AppAuthUserProtocol) not set for a successful sign in simulation." }; 
            throw MockError()
        }
        self.currentUserSession = mockUserSession

        let defaultFetchedUser = StepUp.User(id: mockUserSession.uid, email: email, name: "FetchedName", firstName: "FetchedFirstName")
        self.currentUser = mockFetchedUserData ?? defaultFetchedUser
    }

    func signOut() {
        signOutCalledCount += 1
        if let error = signOutError {
            print("MockAuthProvider: Simulated internal signOut error: \(error.localizedDescription)")
        }
        self.currentUserSession = nil
        self.currentUser = nil
    }

    func deleteAccount() async throws {
        deleteAccountCalledCount += 1
        self.currentUserSession = nil
        self.currentUser = nil
        if let error = deleteAccountError {
            throw error 
        }
    }

    func fetchUserData() async {
        fetchUserDataCalledCount += 1
        guard currentUserSession != nil else {
            self.currentUser = nil
            return
        }

        if let error = fetchUserDataError {
            print("MockAuthProvider: Simulated internal fetchUserData error: \(error.localizedDescription)")
            self.currentUser = nil
            return
        }
        self.currentUser = mockFetchedUserData 
    }

    func updateUserData(name: String, firstName: String) async throws {
        updateUserDataCalledCount += 1
        lastUpdateUserDataName = name
        lastUpdateUserDataFirstName = firstName
        
        if let error = updateUserDataError {
            throw error
        }
        
        guard let currentUser = currentUser else {
            throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user data"])
        }
        
        // Update the current user with new data
        let updatedUser = StepUp.User(
            id: currentUser.id,
            email: currentUser.email,
            name: name,
            firstName: firstName
        )
        self.currentUser = updatedUser
    }

    func reset() {
        currentUserSession = nil
        currentUser = nil
        signUpError = nil
        signInError = nil
        signOutError = nil
        deleteAccountError = nil
        fetchUserDataError = nil
        addUserToDBError = nil
        updateUserDataError = nil
        mockSignUpUserResult = nil
        mockSignInUserResult = nil
        mockFetchedUserData = nil
        signUpCalledCount = 0
        signInCalledCount = 0
        signOutCalledCount = 0
        deleteAccountCalledCount = 0
        fetchUserDataCalledCount = 0
        addUserToDBCalledCount = 0
        updateUserDataCalledCount = 0
        lastSignUpEmail = nil
        lastSignUpPassword = nil
        lastSignUpFirstName = nil
        lastSignUpName = nil
        lastSignInEmail = nil
        lastSignInPassword = nil
        lastAddedUserToDB = nil
        lastUpdateUserDataName = nil
        lastUpdateUserDataFirstName = nil
    }
} 
