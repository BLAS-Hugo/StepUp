import Foundation
@testable import StepUp // To access AppAuthUserProtocol if it's in the main target

// Mock implementation of AppAuthUserProtocol for testing purposes.
struct MockAppAuthUser: AppAuthUserProtocol {
    var uid: String
    var email: String?
    // var displayName: String? // Temporarily commented out

    // --- Test Control Properties ---
    var shouldThrowDeleteError: Error?
    var deleteAsyncCalled: Bool = false // Renamed to avoid conflict if a var named deleteCalled exists

    var idTokenToReturn: String? = "mock_id_token"
    var errorForGetIDToken: Error?
    var getIDTokenCalled: Bool = false

    // Initializer to set up the mock with specific values
    init(uid: String, 
         email: String? = nil, 
         // displayName: String? = nil, // Temporarily commented out
         idTokenToReturn: String? = "mock_id_token",
         errorForGetIDToken: Error? = nil,
         shouldThrowDeleteError: Error? = nil) {
        self.uid = uid
        self.email = email
        // self.displayName = displayName // Temporarily commented out
        self.idTokenToReturn = idTokenToReturn
        self.errorForGetIDToken = errorForGetIDToken
        self.shouldThrowDeleteError = shouldThrowDeleteError
    }

    // --- AppAuthUserProtocol Conformance ---
    mutating func delete() async throws {
        deleteAsyncCalled = true
        if let error = shouldThrowDeleteError {
            throw error
        }
        // Simulate successful deletion (no return value)
    }

    mutating func getIDToken(completion: @escaping (String?, Error?) -> Void) {
        getIDTokenCalled = true
        if let error = errorForGetIDToken {
            completion(nil, error)
        } else {
            completion(idTokenToReturn, nil)
        }
    }
} 
