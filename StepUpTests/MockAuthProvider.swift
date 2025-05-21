import Foundation
import FirebaseAuth
@testable import StepUp // Required for the User type if not defined in test target

// --- Mock Auth Provider ---
@MainActor
class MockAuthProvider: AuthProviding {
    @Published var currentUserSession: AppAuthUserProtocol?
    @Published var currentUser: StepUp.User?

    // Control Properties
    var signUpError: Error?
    var signInError: Error?
    var signOutError: Error? // For simulating internal errors if SUT logs them
    var deleteAccountError: Error? // Used because deleteAccount is now async throws
    var fetchUserDataError: Error? // For simulating internal errors if SUT logs them
    var addUserToDBError: Error?

    var mockSignUpUserResult: AppAuthUserProtocol? // User returned by Firebase Auth on sign up
    var mockSignInUserResult: AppAuthUserProtocol? // User returned by Firebase Auth on sign in
    var mockFetchedUserData: StepUp.User? // User data returned by Firestore fetch

    // Call Trackers
    private(set) var signUpCalledCount = 0
    private(set) var signInCalledCount = 0
    private(set) var signOutCalledCount = 0
    private(set) var deleteAccountCalledCount = 0
    private(set) var fetchUserDataCalledCount = 0
    private(set) var addUserToDBCalledCount = 0

    // Parameter Storage
    private(set) var lastSignUpEmail: String?
    private(set) var lastSignUpPassword: String?
    private(set) var lastSignUpFirstName: String?
    private(set) var lastSignUpName: String?
    private(set) var lastSignInEmail: String?
    private(set) var lastSignInPassword: String?
    private(set) var lastAddedUserToDB: StepUp.User?

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
        // This mock behavior aligns with the SUT's current strategy of clearing local state 
        // before rethrowing, or just clearing if successful.
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

    func reset() {
        currentUserSession = nil
        currentUser = nil
        signUpError = nil
        signInError = nil
        signOutError = nil
        deleteAccountError = nil
        fetchUserDataError = nil
        addUserToDBError = nil
        mockSignUpUserResult = nil
        mockSignInUserResult = nil
        mockFetchedUserData = nil
        signUpCalledCount = 0
        signInCalledCount = 0
        signOutCalledCount = 0
        deleteAccountCalledCount = 0
        fetchUserDataCalledCount = 0
        addUserToDBCalledCount = 0
        lastSignUpEmail = nil
        lastSignUpPassword = nil
        lastSignUpFirstName = nil
        lastSignUpName = nil
        lastSignInEmail = nil
        lastSignInPassword = nil
        lastAddedUserToDB = nil
    }
} 
