//
//  AuthenticationViewModelTests.swift
//  StepUpTests
//
//  Created by Assistant on 23/05/2025.
//

import XCTest
import Combine
@testable import StepUp

@MainActor
final class AuthenticationViewModelTests: XCTestCase {
    var viewModel: AuthenticationViewModel!
    var mockAuthProvider: MockAuthProvider!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAuthProvider = MockAuthProvider()
        viewModel = AuthenticationViewModel(authProvider: mockAuthProvider)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
        viewModel = nil
        mockAuthProvider = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Initialization Tests
    
    func testInit_WithAuthenticatedUser_SetsCorrectState() {
        // Arrange
        let user = User(id: "123", email: "test@example.com", name: "Test", firstName: "User")
        let session = MockAppAuthUser(uid: "123", email: "test@example.com")
        let mockProvider = MockAuthProvider(currentUserSession: session, currentUser: user)
        
        // Act
        let testViewModel = AuthenticationViewModel(authProvider: mockProvider)
        testViewModel.updateAuthenticationState() // Manually trigger state update for mock provider
        
        // Assert
        XCTAssertTrue(testViewModel.isAuthenticated)
        XCTAssertEqual(testViewModel.currentUser?.id, "123")
        XCTAssertEqual(testViewModel.currentUserEmail, "test@example.com")
    }
    
    func testInit_WithNoUser_SetsUnauthenticatedState() {
        // Arrange & Act
        let testViewModel = AuthenticationViewModel(authProvider: MockAuthProvider())
        
        // Assert
        XCTAssertFalse(testViewModel.isAuthenticated)
        XCTAssertNil(testViewModel.currentUser)
        XCTAssertNil(testViewModel.currentUserEmail)
    }
    
    // MARK: - Sign Up Tests
    
    func testSignUp_Success() async throws {
        // Arrange
        let email = "test@example.com"
        let password = "password123"
        let firstName = "Test"
        let name = "User"
        let userSession = MockAppAuthUser(uid: "123", email: email)
        let user = User(id: "123", email: email, name: name, firstName: firstName)
        
        mockAuthProvider.mockSignUpUserResult = userSession
        mockAuthProvider.mockFetchedUserData = user
        
        // Act
        try await viewModel.signUp(email: email, password: password, firstName: firstName, name: name)
        
        // Assert
        XCTAssertEqual(mockAuthProvider.signUpCalledCount, 1)
        XCTAssertEqual(mockAuthProvider.lastSignUpEmail, email)
        XCTAssertEqual(mockAuthProvider.lastSignUpPassword, password)
        XCTAssertEqual(mockAuthProvider.lastSignUpFirstName, firstName)
        XCTAssertEqual(mockAuthProvider.lastSignUpName, name)
        
        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertEqual(viewModel.currentUser?.id, "123")
    }
    
    func testSignUp_Failure() async {
        // Arrange
        let email = "test@example.com"
        let password = "password123"
        let firstName = "Test"
        let name = "User"
        let expectedError = NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Email already exists"])
        
        mockAuthProvider.signUpError = expectedError
        
        // Act & Assert
        do {
            try await viewModel.signUp(email: email, password: password, firstName: firstName, name: name)
            XCTFail("Expected signUp to throw an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
        
        XCTAssertEqual(mockAuthProvider.signUpCalledCount, 1)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.currentUser)
    }
    
    // MARK: - Sign In Tests
    
    func testSignIn_Success() async throws {
        // Arrange
        let email = "test@example.com"
        let password = "password123"
        let userSession = MockAppAuthUser(uid: "123", email: email)
        let user = User(id: "123", email: email, name: "Test", firstName: "User")
        
        mockAuthProvider.mockSignInUserResult = userSession
        mockAuthProvider.mockFetchedUserData = user
        
        // Act
        try await viewModel.signIn(withEmail: email, password: password)
        
        // Assert
        XCTAssertEqual(mockAuthProvider.signInCalledCount, 1)
        XCTAssertEqual(mockAuthProvider.lastSignInEmail, email)
        XCTAssertEqual(mockAuthProvider.lastSignInPassword, password)
        
        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertEqual(viewModel.currentUser?.id, "123")
    }
    
    func testSignIn_Failure() async {
        // Arrange
        let email = "wrong@example.com"
        let password = "wrongpassword"
        let expectedError = NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])
        
        mockAuthProvider.signInError = expectedError
        
        // Act & Assert
        do {
            try await viewModel.signIn(withEmail: email, password: password)
            XCTFail("Expected signIn to throw an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
        
        XCTAssertEqual(mockAuthProvider.signInCalledCount, 1)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.currentUser)
    }
    
    // MARK: - Sign Out Tests
    
    func testSignOut_Success() {
        // Arrange
        let userSession = MockAppAuthUser(uid: "123", email: "test@example.com")
        let user = User(id: "123", email: "test@example.com", name: "Test", firstName: "User")
        mockAuthProvider.currentUserSession = userSession
        mockAuthProvider.currentUser = user
        viewModel.updateAuthenticationState() // Manually trigger update for test setup
        
        XCTAssertTrue(viewModel.isAuthenticated) // Precondition
        
        // Act
        viewModel.signOut()
        
        // Assert
        XCTAssertEqual(mockAuthProvider.signOutCalledCount, 1)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.currentUser)
    }
    
    // MARK: - Delete Account Tests
    
    func testDeleteAccount_Success() async throws {
        // Arrange
        let userSession = MockAppAuthUser(uid: "123", email: "test@example.com")
        let user = User(id: "123", email: "test@example.com", name: "Test", firstName: "User")
        mockAuthProvider.currentUserSession = userSession
        mockAuthProvider.currentUser = user
        
        // Act
        try await viewModel.deleteAccount()
        
        // Assert
        XCTAssertEqual(mockAuthProvider.deleteAccountCalledCount, 1)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.currentUser)
    }
    
    func testDeleteAccount_Failure() async {
        // Arrange
        let userSession = MockAppAuthUser(uid: "123", email: "test@example.com")
        let user = User(id: "123", email: "test@example.com", name: "Test", firstName: "User")
        let expectedError = NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Requires recent login"])
        
        mockAuthProvider.currentUserSession = userSession
        mockAuthProvider.currentUser = user
        mockAuthProvider.deleteAccountError = expectedError
        
        // Act & Assert
        do {
            try await viewModel.deleteAccount()
            XCTFail("Expected deleteAccount to throw an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
        
        XCTAssertEqual(mockAuthProvider.deleteAccountCalledCount, 1)
    }
    
    // MARK: - Update User Data Tests
    
    func testUpdateUserData_Success() async throws {
        // Arrange
        let userSession = MockAppAuthUser(uid: "123", email: "test@example.com")
        let originalUser = User(id: "123", email: "test@example.com", name: "Original", firstName: "Name")
        
        mockAuthProvider.currentUserSession = userSession
        mockAuthProvider.currentUser = originalUser
        
        // Act
        try await viewModel.updateUserData(name: "Updated", firstName: "Name")
        
        // Assert
        XCTAssertEqual(mockAuthProvider.updateUserDataCalledCount, 1)
        XCTAssertEqual(mockAuthProvider.lastUpdateUserDataName, "Updated")
        XCTAssertEqual(mockAuthProvider.lastUpdateUserDataFirstName, "Name")
    }
    
    func testUpdateUserData_Failure() async {
        // Arrange
        let userSession = MockAppAuthUser(uid: "123", email: "test@example.com")
        let user = User(id: "123", email: "test@example.com", name: "Test", firstName: "User")
        let expectedError = NSError(domain: "FirestoreError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        
        mockAuthProvider.currentUserSession = userSession
        mockAuthProvider.currentUser = user
        mockAuthProvider.updateUserDataError = expectedError
        
        // Act & Assert
        do {
            try await viewModel.updateUserData(name: "New", firstName: "Name")
            XCTFail("Expected updateUserData to throw an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
        
        XCTAssertEqual(mockAuthProvider.updateUserDataCalledCount, 1)
    }
    
    // MARK: - Validation Tests
    
    func testValidateEmail() {
        XCTAssertTrue(viewModel.validateEmail("test@example.com"))
        XCTAssertTrue(viewModel.validateEmail("user.name+tag@domain.co.uk"))
        XCTAssertFalse(viewModel.validateEmail("invalid-email"))
        XCTAssertFalse(viewModel.validateEmail("@example.com"))
        XCTAssertFalse(viewModel.validateEmail("test@"))
        XCTAssertFalse(viewModel.validateEmail(""))
    }
    
    func testValidatePassword() {
        XCTAssertTrue(viewModel.validatePassword("password123"))
        XCTAssertTrue(viewModel.validatePassword("123456"))
        XCTAssertFalse(viewModel.validatePassword("12345"))
        XCTAssertFalse(viewModel.validatePassword(""))
    }
    
    func testValidateName() {
        XCTAssertTrue(viewModel.validateName("John"))
        XCTAssertTrue(viewModel.validateName("Jean-Claude"))
        XCTAssertTrue(viewModel.validateName("Mary Anne"))
        XCTAssertFalse(viewModel.validateName(""))
        XCTAssertFalse(viewModel.validateName("   "))
        XCTAssertFalse(viewModel.validateName("\t\n"))
    }
    
    // MARK: - State Management Tests
    
    func testIsAuthenticated_RequiresBothSessionAndUser() {
        // Initially not authenticated
        XCTAssertFalse(viewModel.isAuthenticated)
        
        // Session only - not authenticated
        mockAuthProvider.currentUserSession = MockAppAuthUser(uid: "123", email: "test@example.com")
        viewModel.updateAuthenticationState()
        XCTAssertFalse(viewModel.isAuthenticated)
        
        // Session + User - authenticated
        mockAuthProvider.currentUser = User(id: "123", email: "test@example.com", name: "Test", firstName: "User")
        viewModel.updateAuthenticationState()
        XCTAssertTrue(viewModel.isAuthenticated)
        
        // User only - not authenticated
        mockAuthProvider.currentUserSession = nil
        viewModel.updateAuthenticationState()
        XCTAssertFalse(viewModel.isAuthenticated)
    }
    
    func testCurrentUserEmail_ReflectsAuthProviderSession() {
        // No session
        XCTAssertNil(viewModel.currentUserEmail)
        
        // With session
        mockAuthProvider.currentUserSession = MockAppAuthUser(uid: "123", email: "test@example.com")
        XCTAssertEqual(viewModel.currentUserEmail, "test@example.com")
    }
    
    // MARK: - Refresh Authentication State Tests
    
    func testRefreshAuthenticationState_Success() async {
        // Arrange
        let userSession = MockAppAuthUser(uid: "123", email: "test@example.com")
        let user = User(id: "123", email: "test@example.com", name: "Test", firstName: "User")
        
        mockAuthProvider.currentUserSession = userSession
        mockAuthProvider.mockFetchedUserData = user
        
        // Act
        await viewModel.refreshAuthenticationState()
        
        // Assert
        XCTAssertEqual(mockAuthProvider.fetchUserDataCalledCount, 1)
        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertEqual(viewModel.currentUser?.id, "123")
    }
    
    func testRefreshAuthenticationState_WithFetchError() async {
        // Arrange
        let userSession = MockAppAuthUser(uid: "123", email: "test@example.com")
        let fetchError = NSError(domain: "FetchError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        
        mockAuthProvider.currentUserSession = userSession
        mockAuthProvider.fetchUserDataError = fetchError
        
        // Act
        await viewModel.refreshAuthenticationState()
        
        // Assert
        XCTAssertEqual(mockAuthProvider.fetchUserDataCalledCount, 1)
        // When fetch fails, MockAuthProvider clears currentUser, so authentication should be false
        XCTAssertFalse(viewModel.isAuthenticated) // Session exists but currentUser is nil due to fetch error
        XCTAssertNil(viewModel.currentUser)
    }
    
    func testRefreshAuthenticationState_UpdatesCurrentUser() async {
        // Arrange - start with no user
        mockAuthProvider.currentUser = nil
        viewModel.updateAuthenticationState()
        XCTAssertNil(viewModel.currentUser)
        
        // Set up user data to be fetched
        let userSession = MockAppAuthUser(uid: "456", email: "new@example.com")
        let newUser = User(id: "456", email: "new@example.com", name: "New", firstName: "User")
        
        mockAuthProvider.currentUserSession = userSession
        mockAuthProvider.mockFetchedUserData = newUser
        
        // Act
        await viewModel.refreshAuthenticationState()
        
        // Assert
        XCTAssertEqual(mockAuthProvider.fetchUserDataCalledCount, 1)
        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertEqual(viewModel.currentUser?.id, "456")
        XCTAssertEqual(viewModel.currentUser?.email, "new@example.com")
    }
    
    func testRefreshAuthenticationState_ConcurrentCalls() async {
        // Arrange
        let userSession = MockAppAuthUser(uid: "123", email: "test@example.com")
        let user = User(id: "123", email: "test@example.com", name: "Test", firstName: "User")
        
        mockAuthProvider.currentUserSession = userSession
        mockAuthProvider.mockFetchedUserData = user
        
        // Act - make multiple concurrent calls
        async let call1: () = viewModel.refreshAuthenticationState()
        async let call2: () = viewModel.refreshAuthenticationState()
        async let call3: () = viewModel.refreshAuthenticationState()
        
        await call1
        await call2
        await call3
        
        // Assert
        XCTAssertEqual(mockAuthProvider.fetchUserDataCalledCount, 3)
        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertEqual(viewModel.currentUser?.id, "123")
    }

    // MARK: - State Management Edge Cases

    func testCurrentUserEmail_WithNilEmail() {
        // With session but no email
        mockAuthProvider.currentUserSession = MockAppAuthUser(uid: "123", email: nil)
        XCTAssertNil(viewModel.currentUserEmail)
    }

    func testRefreshAuthenticationState_WithNoSession() async {
        // Arrange - no user session
        mockAuthProvider.currentUserSession = nil

        // Act
        await viewModel.refreshAuthenticationState()

        // Assert
        XCTAssertEqual(mockAuthProvider.fetchUserDataCalledCount, 1)
        XCTAssertFalse(viewModel.isAuthenticated)
    }

}
