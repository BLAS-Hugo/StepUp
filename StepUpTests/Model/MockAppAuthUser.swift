import Foundation
@testable import StepUp

struct MockAppAuthUser: AppAuthUserProtocol {
    var uid: String
    var email: String?

    var shouldThrowDeleteError: Error?
    var deleteAsyncCalled: Bool = false

    var idTokenToReturn: String? = "mock_id_token"
    var errorForGetIDToken: Error?
    var getIDTokenCalled: Bool = false

    init(uid: String,
         email: String? = nil, 
         idTokenToReturn: String? = "mock_id_token",
         errorForGetIDToken: Error? = nil,
         shouldThrowDeleteError: Error? = nil) {
        self.uid = uid
        self.email = email
        self.idTokenToReturn = idTokenToReturn
        self.errorForGetIDToken = errorForGetIDToken
        self.shouldThrowDeleteError = shouldThrowDeleteError
    }

    mutating func delete() async throws {
        deleteAsyncCalled = true
        if let error = shouldThrowDeleteError {
            throw error
        }
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
