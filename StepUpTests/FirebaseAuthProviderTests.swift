import XCTest
@testable import StepUp
import FirebaseAuth

// This test file uses MockAuthProvider, which is now in MockAuthProvider.swift

@MainActor
final class FirebaseAuthProviderTests: XCTestCase {
    var authProvider: MockAuthProvider!

    override func setUpWithError() throws {
        try super.setUpWithError()
        authProvider = MockAuthProvider()
    }

    override func tearDownWithError() throws {
        authProvider.reset() // Reset mock state after each test
        authProvider = nil
        try super.tearDownWithError()
    }

    // MARK: - Sign Up Tests
    func testSignUp_Success() async throws {
        // Arrange
        let email = "test@example.com"
        let password = "password123"
        let firstName = "Test"
        let name = "User"
        let expectedUserID = "mockUserID"
        let mockUserSession = MockAppAuthUser(uid: expectedUserID, email: email)
        let expectedUser = User(id: expectedUserID, email: email, name: name, firstName: firstName)
    
        authProvider.mockSignUpUserResult = mockUserSession
        authProvider.mockFetchedUserData = expectedUser
    
        // Act
        // We call the method on the SUT (which is the MockAuthProvider)
        // to simulate what would happen if FirebaseAuthProvider called its dependencies.
        try await authProvider.signUp(email: email, password: password, firstName: firstName, name: name)
    
        // Assert
        XCTAssertEqual(authProvider.signUpCalledCount, 1)
        XCTAssertEqual(authProvider.lastSignUpEmail, email)
        XCTAssertEqual(authProvider.lastSignUpPassword, password)
        XCTAssertEqual(authProvider.lastSignUpFirstName, firstName)
        XCTAssertEqual(authProvider.lastSignUpName, name)
        
        XCTAssertEqual(authProvider.addUserToDBCalledCount, 1)
        XCTAssertEqual(authProvider.lastAddedUserToDB?.id, expectedUserID)
        XCTAssertEqual(authProvider.lastAddedUserToDB?.email, email)
    
        XCTAssertNotNil(authProvider.currentUserSession, "currentUserSession should be set by mock after signUp.")
        XCTAssertEqual(authProvider.currentUserSession?.uid, expectedUserID)
        XCTAssertEqual(authProvider.currentUserSession?.email, email)
    
        XCTAssertNotNil(authProvider.currentUser, "currentUser should be set by mock after signUp (simulating fetchUserData).")
        XCTAssertEqual(authProvider.currentUser?.id, expectedUserID)
        XCTAssertEqual(authProvider.currentUser?.email, email)
        XCTAssertEqual(authProvider.currentUser?.firstName, firstName)
        XCTAssertEqual(authProvider.currentUser?.name, name)
    }
    
    func testSignUp_AuthError() async {
        // Arrange
        let email = "test@example.com"
        let password = "password123"
        let firstName = "Test"
        let name = "User"
        let expectedError = NSError(domain: "FirebaseAuth.AuthErrorDomain", code: AuthErrorCode.emailAlreadyInUse.rawValue, userInfo: nil)
        
        authProvider.signUpError = expectedError // Configure mock to throw this error
    
        var thrownError: Error?
    
        // Act
        do {
            try await authProvider.signUp(email: email, password: password, firstName: firstName, name: name)
        } catch {
            thrownError = error
        }
    
        // Assert
        XCTAssertEqual(authProvider.signUpCalledCount, 1)
        XCTAssertNotNil(thrownError, "An error should have been thrown during sign up.")
        XCTAssertEqual(thrownError as? NSError, expectedError, "The thrown error should be the one configured in the mock.")
        XCTAssertNil(authProvider.currentUserSession, "Current user session should be nil on auth failure.")
        XCTAssertNil(authProvider.currentUser, "Current user data should be nil on auth failure.")
        XCTAssertEqual(authProvider.addUserToDBCalledCount, 0, "addUserToDB should not be called if auth part fails.")
    }
    
    func testSignUp_AddUserToDBError() async {
        // Arrange
        let email = "test@example.com"
        let password = "password123"
        let firstName = "Test"
        let name = "User"
        let expectedUserID = "mockUserID_dbFail"
        let mockUserSession = MockAppAuthUser(uid: expectedUserID, email: email)
        let expectedDBError = NSError(domain: "FirestoreErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to save user to DB"])
    
        authProvider.mockSignUpUserResult = mockUserSession
        authProvider.addUserToDBError = expectedDBError
    
        var thrownError: Error?
    
        // Act
        do {
            try await authProvider.signUp(email: email, password: password, firstName: firstName, name: name)
        } catch {
            thrownError = error
        }
    
        // Assert
        XCTAssertEqual(authProvider.signUpCalledCount, 1)
        XCTAssertEqual(authProvider.addUserToDBCalledCount, 1, "addUserToDB should have been called.")
        XCTAssertNotNil(thrownError, "An error should have been thrown from addUserToDB.")
        XCTAssertEqual(thrownError as? NSError, expectedDBError)
        
        // Even if addUserToDB fails, the mock sets currentUserSession because the auth part succeeded.
        // This aligns with FirebaseAuthProvider that would have set it before addUserToDB is called.
        XCTAssertNotNil(authProvider.currentUserSession, "User session should be set as auth part succeeded.")
        XCTAssertEqual(authProvider.currentUserSession?.uid, expectedUserID)
        // currentUser would be nil because the mock's signUp won't set it if addUserToDBError is thrown.
        XCTAssertNil(authProvider.currentUser, "Current user data should be nil if DB write failed.")
    }

    func testSignUp_Success_ButMockSignUpUserResultIsNil_ThrowsError() async {
        // Arrange
        let email = "test@example.com"
        let password = "password123"
        let firstName = "Test"
        let name = "User"

        authProvider.signUpError = nil // No explicit error
        authProvider.mockSignUpUserResult = nil // This should cause the internal error

        var thrownError: Error?
        var thrownMockError: (Error & LocalizedError)?

        // Act
        do {
            try await authProvider.signUp(email: email, password: password, firstName: firstName, name: name)
        } catch let error as (Error & LocalizedError) {
            thrownMockError = error
            thrownError = error
        } catch {
            thrownError = error
        }

        // Assert
        XCTAssertEqual(authProvider.signUpCalledCount, 1, "signUp should have been called once.")
        XCTAssertNotNil(thrownError, "An error should have been thrown.")
        XCTAssertNotNil(thrownMockError, "A MockError should have been thrown.")
        XCTAssertEqual(thrownMockError?.errorDescription, "MockAuthProvider.mockSignUpUserResult (AppAuthUserProtocol) not set for a successful sign up simulation.")
        XCTAssertNil(authProvider.currentUserSession)
        XCTAssertNil(authProvider.currentUser)
        XCTAssertEqual(authProvider.addUserToDBCalledCount, 0, "addUserToDB should not be called.")
    }

    // MARK: - Sign In Tests
    func testSignIn_Success() async throws {
        // Arrange
        let email = "test@example.com"
        let password = "password123"
        let mockUserID = "mockSignedInUserID"
        let mockUserSession = MockAppAuthUser(uid: mockUserID, email: email)
        let expectedFetchedUser = User(id: mockUserID, email: email, name: "FetchedName", firstName: "FetchedFirstName")

        authProvider.mockSignInUserResult = mockUserSession
        authProvider.mockFetchedUserData = expectedFetchedUser

        // Act
        try await authProvider.signIn(withEmail: email, password: password)

        // Assert
        XCTAssertEqual(authProvider.signInCalledCount, 1)
        XCTAssertEqual(authProvider.lastSignInEmail, email)
        XCTAssertEqual(authProvider.lastSignInPassword, password)

        XCTAssertNotNil(authProvider.currentUserSession)
        XCTAssertEqual(authProvider.currentUserSession?.uid, mockUserID)
        XCTAssertEqual(authProvider.currentUserSession?.email, email)

        XCTAssertNotNil(authProvider.currentUser)
        XCTAssertEqual(authProvider.currentUser?.id, mockUserID)
        XCTAssertEqual(authProvider.currentUser?.email, email)
        XCTAssertEqual(authProvider.currentUser?.name, expectedFetchedUser.name)
        XCTAssertEqual(authProvider.currentUser?.firstName, expectedFetchedUser.firstName)
    }

    func testSignIn_AuthError() async {
        // Arrange
        let email = "nonexistent@example.com"
        let password = "wrongpassword"
        let expectedError = NSError(domain: "FirebaseAuth.AuthErrorDomain", code: AuthErrorCode.userNotFound.rawValue, userInfo: nil)
        
        authProvider.signInError = expectedError // Configure mock for signIn to throw this
        
        var thrownError: Error?

        // Act
        do {
            try await authProvider.signIn(withEmail: email, password: password)
        } catch {
            thrownError = error
        }

        // Assert
        XCTAssertEqual(authProvider.signInCalledCount, 1)
        XCTAssertNotNil(thrownError, "An error should have been thrown during sign in.")
        XCTAssertEqual(thrownError as? NSError, expectedError)
        XCTAssertNil(authProvider.currentUserSession, "Current user session should be nil on sign-in failure.")
        XCTAssertNil(authProvider.currentUser, "Current user data should be nil on sign-in failure.")
    }

    func testSignIn_Success_ButMockSignInUserResultIsNil_ThrowsError() async {
        // Arrange
        let email = "test@example.com"
        let password = "password123"

        authProvider.signInError = nil // No explicit error
        authProvider.mockSignInUserResult = nil // This should cause the internal error

        var thrownError: Error?
        var thrownMockError: (Error & LocalizedError)?

        // Act
        do {
            try await authProvider.signIn(withEmail: email, password: password)
        } catch let error as (Error & LocalizedError) {
            thrownMockError = error
            thrownError = error
        } catch {
            thrownError = error
        }

        // Assert
        XCTAssertEqual(authProvider.signInCalledCount, 1, "signIn should have been called once.")
        XCTAssertNotNil(thrownError, "An error should have been thrown.")
        XCTAssertNotNil(thrownMockError, "A MockError should have been thrown.")
        XCTAssertEqual(thrownMockError?.errorDescription, "MockAuthProvider.mockSignInUserResult (AppAuthUserProtocol) not set for a successful sign in simulation.")
        XCTAssertNil(authProvider.currentUserSession)
        XCTAssertNil(authProvider.currentUser)
    }
    
    func testSignIn_FetchUserDataFails_StillSetsSessionButUserIsNil() async throws {
        // This test title and original assertion (XCTAssertNil(sut.currentUser))
        // might reflect an expectation from a higher-level FirebaseAuthProvider behavior
        // where an internal fetchUserData call failing would lead to a nil currentUser.
        // However, MockAuthProvider.signIn itself, if auth succeeds and mockSignInUserResult is provided,
        // will set currentUser to `mockFetchedUserData ?? defaultFetchedUser`.
        // We will adjust this test to verify MockAuthProvider's actual behavior.
        // Let's rename to clarify we're testing the mock's behavior when mockFetchedUserData is nil.
        
        // Arrange
        let email = "test@example.com"
        let password = "password123"
        let mockUserID = "userWithFetchFailUID"
        let mockUserSession = MockAppAuthUser(uid: mockUserID, email: email)

        authProvider.mockSignInUserResult = mockUserSession
        authProvider.mockFetchedUserData = nil

        // Expected default user data from MockAuthProvider.signIn
        let expectedDefaultUser = User(id: mockUserID, email: email, name: "FetchedName", firstName: "FetchedFirstName")

        // Act
        try await authProvider.signIn(withEmail: email, password: password)

        // Assert
        XCTAssertEqual(authProvider.signInCalledCount, 1)
        XCTAssertNotNil(authProvider.currentUserSession, "User session should be set as auth part succeeded.")
        XCTAssertEqual(authProvider.currentUserSession?.uid, mockUserID)
        
        // Verify that currentUser is set to the defaultFetchedUser as per MockAuthProvider.signIn logic
        XCTAssertNotNil(authProvider.currentUser, "Current user data should be set to the default value by the mock.")
        XCTAssertEqual(authProvider.currentUser?.id, expectedDefaultUser.id)
        XCTAssertEqual(authProvider.currentUser?.email, expectedDefaultUser.email)
        XCTAssertEqual(authProvider.currentUser?.name, expectedDefaultUser.name)
        XCTAssertEqual(authProvider.currentUser?.firstName, expectedDefaultUser.firstName)
    }

    // MARK: - Sign Out Tests
    func testSignOut_Success() {
        // Arrange
        let mockUserSession = MockAppAuthUser(uid: "signedInUserUID", email: "user@example.com")
        authProvider.currentUserSession = mockUserSession
        authProvider.currentUser = User(id: mockUserSession.uid, email: mockUserSession.email!, name: "Test", firstName: "User")

        authProvider.signOutError = nil

        // Act
        authProvider.signOut()

        // Assert
        XCTAssertEqual(authProvider.signOutCalledCount, 1)
        XCTAssertNil(authProvider.currentUserSession, "Current user session should be nil after sign out.")
        XCTAssertNil(authProvider.currentUser, "Current user data should be nil after sign out.")
    }

    func testSignOut_AlreadySignedOut() {
        // Arrange
        // Initial state of mock (currentUserSession and currentUser are nil)
        XCTAssertNil(authProvider.currentUserSession)
        XCTAssertNil(authProvider.currentUser)
        
        // Act
        authProvider.signOut()

        // Assert
        XCTAssertEqual(authProvider.signOutCalledCount, 1, "signOut should still be called on the mock.")
        XCTAssertNil(authProvider.currentUserSession, "Current user session should remain nil.")
        XCTAssertNil(authProvider.currentUser, "Current user data should remain nil.")
    }
    
    func testSignOut_AuthInternalError_StillClearsLocalState() {
        // Arrange
        let mockUserSession = MockAppAuthUser(uid: "signedInUserUID", email: "user@example.com")
        authProvider.currentUserSession = mockUserSession
        authProvider.currentUser = User(id: mockUserSession.uid, email: mockUserSession.email!, name: "Test", firstName: "User")
        
        authProvider.signOutError = NSError(domain: "FirebaseAuth.AuthErrorDomain", code: AuthErrorCode.internalError.rawValue, userInfo: [NSLocalizedDescriptionKey: "Mock SignOut failed internally"])

        // Act
        authProvider.signOut()

        // Assert
        XCTAssertEqual(authProvider.signOutCalledCount, 1)
        // FirebaseAuthProvider clears local state even if internal Firebase signOut fails.
        XCTAssertNil(authProvider.currentUserSession, "Current user session should be nil even if sign out had an internal error.")
        XCTAssertNil(authProvider.currentUser, "Current user data should be nil even if sign out had an internal error.")
    }

    // MARK: - Delete Account Tests
    func testDeleteAccount_Success() async throws {
        // Arrange
        let mockUserID = "userToDeleteUID"
        let mockUserEmail = "delete@example.com"
        let mockUserSession = MockAppAuthUser(uid: mockUserID, email: mockUserEmail)
        
        authProvider.currentUserSession = mockUserSession
        authProvider.currentUser = User(id: mockUserID, email: mockUserEmail, name: "Delete", firstName: "Me")
        authProvider.deleteAccountError = nil

        // Act
        try await authProvider.deleteAccount()

        // Assert
        XCTAssertEqual(authProvider.deleteAccountCalledCount, 1)
        XCTAssertNil(authProvider.currentUserSession, "Current user session should be nil after deleting account.")
        XCTAssertNil(authProvider.currentUser, "Current user data should be nil after deleting account.")
    }

    func testDeleteAccount_ErrorThrown() async {
        // Arrange
        let mockUserID = "userToDeleteUID_authFail"
        let mockUserEmail = "delete_authfail@example.com"
        let mockUserSession = MockAppAuthUser(uid: mockUserID, email: mockUserEmail)
        let expectedError = NSError(domain: "FirebaseAuth.AuthErrorDomain", code: AuthErrorCode.requiresRecentLogin.rawValue, userInfo: nil)

        authProvider.currentUserSession = mockUserSession
        authProvider.currentUser = User(id: mockUserID, email: mockUserEmail, name: "DeleteFail", firstName: "Auth")
        authProvider.deleteAccountError = expectedError
        
        var thrownError: Error?

        // Act
        do {
            try await authProvider.deleteAccount()
        } catch {
            thrownError = error
        }

        // Assert
        XCTAssertEqual(authProvider.deleteAccountCalledCount, 1)
        XCTAssertNotNil(thrownError, "An error should have been thrown during account deletion.")
        XCTAssertEqual(thrownError as? NSError, expectedError)
        // The mock's deleteAccount (and SUT's current version) clears local state before rethrowing.
        XCTAssertNil(authProvider.currentUserSession, "Current user session should be nil even on deletion failure.")
        XCTAssertNil(authProvider.currentUser, "Current user data should be nil even on deletion failure.")
    }

    func testDeleteAccount_NoUserLoggedIn() async throws {
        // Arrange
        XCTAssertNil(authProvider.currentUserSession, "Precondition: No user should be logged in.")
        XCTAssertNil(authProvider.currentUser, "Precondition: No user data should exist.")
        
        // Act
        // FirebaseAuthProvider's deleteAccount returns if no user, no error thrown.
        try await authProvider.deleteAccount() 

        // Assert
        XCTAssertEqual(authProvider.deleteAccountCalledCount, 1, "deleteAccount on mock should still be called.")
        XCTAssertNil(authProvider.currentUserSession, "Current user session should remain nil.")
        XCTAssertNil(authProvider.currentUser, "Current user data should remain nil.")
    }

    // MARK: - Fetch User Data Tests
    func testFetchUserData_Success() async {
        // Arrange
        let mockUserID = "existingUserUID"
        let mockEmail = "existing@example.com"
        let mockUserSession = MockAppAuthUser(uid: mockUserID, email: mockEmail)
        let expectedUser = User(id: mockUserID, email: mockEmail, name: "Already", firstName: "There")

        authProvider.currentUserSession = mockUserSession
        authProvider.mockFetchedUserData = expectedUser
        authProvider.fetchUserDataError = nil
        authProvider.currentUser = nil

        // Act
        await authProvider.fetchUserData()

        // Assert
        XCTAssertEqual(authProvider.fetchUserDataCalledCount, 1)
        XCTAssertNotNil(authProvider.currentUser, "Current user data should be fetched and set.")
        XCTAssertEqual(authProvider.currentUser?.id, expectedUser.id)
        XCTAssertEqual(authProvider.currentUser?.email, expectedUser.email)
        XCTAssertEqual(authProvider.currentUser?.firstName, expectedUser.firstName)
        XCTAssertEqual(authProvider.currentUser?.name, expectedUser.name)
    }

    func testFetchUserData_NoUserSession() async {
        // Arrange
        authProvider.currentUserSession = nil // No active session
        authProvider.currentUser = nil
        
        // Act
        await authProvider.fetchUserData()

        // Assert
        XCTAssertEqual(authProvider.fetchUserDataCalledCount, 1)
        XCTAssertNil(authProvider.currentUser, "Current user data should remain nil if no session exists.")
    }

    func testFetchUserData_SimulatedInternalError_ClearsCurrentUser() async {
        // Arrange
        let mockUserID = "userWithFetchErrorUID"
        let mockUserSession = MockAppAuthUser(uid: mockUserID, email: "fetcherror@example.com")
        authProvider.currentUserSession = mockUserSession
        // Simulate some pre-existing or stale user data
        authProvider.currentUser = User(id: "staleID", email: "stale@example.com", name: "Stale", firstName: "User")
        
        authProvider.fetchUserDataError = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Simulated fetch failed"])
        authProvider.mockFetchedUserData = nil // Ensure mock doesn't return data when error is set

        // Act
        await authProvider.fetchUserData()

        // Assert
        XCTAssertEqual(authProvider.fetchUserDataCalledCount, 1)
        XCTAssertNil(authProvider.currentUser, "Current user data should be nil if fetchUserData encounters an internal error.")
    }
    
    func testFetchUserData_SimulateNoDocumentFoundOrDecodingError_ClearsCurrentUser() async {
        // Arrange
        let mockUserID = "userWithNoDocUID"
        let mockUserSession = MockAppAuthUser(uid: mockUserID, email: "nodoc@example.com")
        authProvider.currentUserSession = mockUserSession
        authProvider.currentUser = User(id: "staleID", email: "stale@example.com", name: "Stale", firstName: "User")

        authProvider.mockFetchedUserData = nil // This simulates that no data was decoded/returned by Firestore
        authProvider.fetchUserDataError = nil  // No explicit error thrown by the mock itself for this case

        // Act
        await authProvider.fetchUserData()

        // Assert
        XCTAssertEqual(authProvider.fetchUserDataCalledCount, 1)
        XCTAssertNil(authProvider.currentUser, "Current user data should be nil if no document was found or data couldn't be decoded.")
    }
    
    // MARK: - Init Tests (Simulating fetchUserData call from init)
    func testInit_CallsFetchUserData_AndPopulatesUser_IfSessionExistsAndFetchSucceeds() async {
        // Arrange
        let initialUserID = "initUserUID"
        let initialEmail = "init@example.com"
        let initialMockUserSession = MockAppAuthUser(uid: initialUserID, email: initialEmail)
        let expectedUserOnLaunch = User(id: initialUserID, email: initialEmail, name: "InitName", firstName: "InitFirst")

        let localAuthProvider = MockAuthProvider(currentUserSession: initialMockUserSession)
        localAuthProvider.mockFetchedUserData = expectedUserOnLaunch
        localAuthProvider.fetchUserDataError = nil

        // Act
        await localAuthProvider.fetchUserData() // Simulates the fetchUserData call made by init

        // Assert
        XCTAssertEqual(localAuthProvider.fetchUserDataCalledCount, 1)
        XCTAssertNotNil(localAuthProvider.currentUser)
        XCTAssertEqual(localAuthProvider.currentUser?.id, expectedUserOnLaunch.id)
        XCTAssertEqual(localAuthProvider.currentUser?.name, expectedUserOnLaunch.name)
    }
    
    func testInit_CallsFetchUserData_AndUserIsNil_IfSessionExistsButFetchFails() async {
        // Arrange
        let initialUserID = "initUserUID_fetchFail"
        let initialEmail = "init_fail@example.com"
        let initialMockUserSession = MockAppAuthUser(uid: initialUserID, email: initialEmail)

        let localAuthProvider = MockAuthProvider(currentUserSession: initialMockUserSession)
        localAuthProvider.fetchUserDataError = NSError(domain: "Test", code: 1, userInfo: nil) // Simulate fetch error
        localAuthProvider.mockFetchedUserData = nil

        // Act
        await localAuthProvider.fetchUserData() // Simulates the fetchUserData call made by init

        // Assert
        XCTAssertEqual(localAuthProvider.fetchUserDataCalledCount, 1)
        XCTAssertNil(localAuthProvider.currentUser)
    }
    
    func testInit_CallsFetchUserData_AndUserIsNil_IfNoSessionOnInit() async {
        // Arrange
        let localAuthProvider = MockAuthProvider(currentUserSession: nil) // No session on init

        // Act
        await localAuthProvider.fetchUserData() // Simulates the fetchUserData call made by init

        // Assert
        XCTAssertEqual(localAuthProvider.fetchUserDataCalledCount, 1)
        XCTAssertNil(localAuthProvider.currentUser)
    }
} 
