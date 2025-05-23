import Foundation
import FirebaseFirestore

class FirestoreChallengeStore: ChallengeStoring {
    private let challengesCollection = Firestore.firestore().collection("challenges")
    private let encoder = Firestore.Encoder()
    private let decoder = Firestore.Decoder()

    func fetchChallenges() async throws -> [Challenge] {
        var challenges: [Challenge] = []
        let collectionSnapshot = try await challengesCollection.getDocuments()

        for document in collectionSnapshot.documents {
            do {
                var challengeData = try decoder.decode(Challenge.self, from: document.data())
                challengeData.id = document.documentID
                challenges.append(challengeData)
            } catch {
                print("Error decoding challenge with ID \(document.documentID): \(error.localizedDescription)")
            }
        }
        return challenges
    }

    func createChallenge(_ challenge: Challenge) async throws {
        let encodedChallenge = try encoder.encode(challenge)
        try await challengesCollection.addDocument(data: encodedChallenge)
    }

    func editChallenge(_ challenge: Challenge) async throws {
        guard let challengeID = challenge.id else {
            struct MissingIDError: Error, LocalizedError { var errorDescription: String? = "Challenge ID is missing for edit." }
            throw MissingIDError()
        }
        let encodedChallenge = try encoder.encode(challenge)
        try await challengesCollection.document(challengeID).setData(encodedChallenge)
    }

    func deleteChallenge(_ challenge: Challenge) async throws {
        guard let challengeID = challenge.id else {
            struct MissingIDError: Error, LocalizedError { var errorDescription: String? = "Challenge ID is missing for delete." }
            throw MissingIDError()
        }
        try await challengesCollection.document(challengeID).delete()
    }
}
