import Foundation

protocol ChallengeStoring {
    func fetchChallenges() async throws -> [Challenge]
    func createChallenge(_ challenge: Challenge) async throws
    func editChallenge(_ challenge: Challenge) async throws
    func deleteChallenge(_ challenge: Challenge) async throws
}
