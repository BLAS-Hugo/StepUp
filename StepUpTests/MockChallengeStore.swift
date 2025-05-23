import Foundation
@testable import StepUp // To access Challenge and ChallengeStoring
import XCTest // For UUID, though Foundation might be enough if UUID is the only thing

class MockChallengeStore: ChallengeStoring {
    var challengesToReturn: [Challenge] = []
    var errorToThrow: Error?
    var shouldThrowOnFetch: Bool = false
    var shouldThrowOnCreate: Bool = false
    var shouldThrowOnEdit: Bool = false
    var shouldThrowOnDelete: Bool = false

    // To track calls and passed data
    private(set) var fetchedChallengesCalled = false
    private(set) var createdChallenge: Challenge?
    private(set) var editedChallenge: Challenge?
    private(set) var deletedChallenge: Challenge?

    // In-memory store for basic simulation
    var challenges: [Challenge] = []

    func fetchChallenges() async throws -> [Challenge] {
        fetchedChallengesCalled = true
        if shouldThrowOnFetch, let error = errorToThrow {
            throw error
        }
        return challengesToReturn
    }

    func createChallenge(_ challenge: Challenge) async throws {
        createdChallenge = challenge
        if shouldThrowOnCreate, let error = errorToThrow {
            throw error
        }
        // Simulate adding to an in-memory store if needed for more complex tests
        if !shouldThrowOnCreate {
            var newChallenge = challenge
            if newChallenge.id == nil {
                newChallenge.id = UUID().uuidString // Simulate ID generation
            }
            challenges.append(newChallenge)
        }
    }

    func editChallenge(_ challenge: Challenge) async throws {
        editedChallenge = challenge
        if shouldThrowOnEdit, let error = errorToThrow {
            throw error
        }

        if !shouldThrowOnEdit, let index = challenges.firstIndex(where: { $0.id == challenge.id }) {
            challenges[index] = challenge
        }
    }

    func deleteChallenge(_ challenge: Challenge) async throws {
        deletedChallenge = challenge
        if shouldThrowOnDelete, let error = errorToThrow {
            throw error
        }
        // Simulate deleting from an in-memory store
        if !shouldThrowOnDelete {
            challenges.removeAll(where: { $0.id == challenge.id })
        }
    }

    func reset() {
        challengesToReturn = []
        errorToThrow = nil
        shouldThrowOnFetch = false
        shouldThrowOnCreate = false
        shouldThrowOnEdit = false
        shouldThrowOnDelete = false
        fetchedChallengesCalled = false
        createdChallenge = nil
        editedChallenge = nil
        deletedChallenge = nil
        challenges = []
    }
}
