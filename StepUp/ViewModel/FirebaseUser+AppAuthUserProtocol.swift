import FirebaseAuth

// Extension to make the concrete FirebaseAuth.User class conform to our AppAuthUserProtocol.
// This allows us to use FirebaseAuth.User instances wherever an AppAuthUserProtocol is expected,
// bridging the Firebase SDK type to our application's abstraction.

extension FirebaseAuth.User: AppAuthUserProtocol {
    func getIDToken(completion: @escaping (String?, (any Error)?) -> Void) {
        return
    }
}
