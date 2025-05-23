import Foundation
import FirebaseAuth

protocol AppAuthUserProtocol {
    var uid: String { get }
    var email: String? { get }

    mutating func delete() async throws

    mutating func getIDToken(completion: @escaping (String?, Error?) -> Void)
}

extension FirebaseAuth.User: AppAuthUserProtocol {
    func getIDToken(completion: @escaping (String?, (any Error)?) -> Void) {
        return
    }
}
