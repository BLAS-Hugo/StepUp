import Foundation

protocol AppAuthUserProtocol {
    var uid: String { get }
    var email: String? { get }
    // var displayName: String? { get } // Temporarily commented out to check conformance
    // var photoURL: URL? { get }    // Example, add if used

    mutating func delete() async throws

    mutating func getIDToken(completion: @escaping (String?, Error?) -> Void)
}
