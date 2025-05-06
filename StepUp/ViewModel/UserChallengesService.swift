//
//  UserChallengesService.swift
//  StepUp
//
//  Created by Hugo Blas on 24/03/2025.
//

import FirebaseCore
import FirebaseFirestore

@MainActor
class UserChallengesService: ObservableObject {
    let authenticationService: AuthenticationService

    @Published var challenges: [Challenge] = []
    @Published var userCreatedChallenges: [Challenge] = []
    @Published var userParticipatingChallenges: [Challenge] = []
    @Published var userCurrentChallenge: Challenge? = nil
    @Published var otherChallenges: [Challenge] = []

    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
        if self.authenticationService.currentUser == nil {
            return
        }
        Task {
            await fetchChallenges(forUser: self.authenticationService.currentUser)
        }
    }

    func createChallenge(_ challenge: Challenge, forUser user: User?) async throws {
        if user == nil {
            return
        }
        let encodedChallenge = try Firestore.Encoder().encode(challenge)
        try await challengesCollection.addDocument(data: encodedChallenge)
        await fetchChallenges(forUser: user)
    }

    func editChallenge(_ challenge: Challenge, forUser user: User?) async throws {
        if user == nil || challenge.id == nil {
            return
        }
        let encodedChallenge = try Firestore.Encoder().encode(challenge)
        try await challengesCollection.document(challenge.id!).setData(encodedChallenge)
        await fetchChallenges(forUser: user)
    }

    func deleteChallenge(_ challenge: Challenge, forUser user: User?) async throws {
        if user == nil || challenge.id == nil {
            return
        }
        try await challengesCollection.document(challenge.id!).delete()
        await fetchChallenges(forUser: user)
    }

    func fetchChallenges(forUser user: User?) async {
        challenges = []
        if user == nil {
            return
        }
        guard let collectionSnapshot = try? await challengesCollection.getDocuments()
        else { return }

        for document in collectionSnapshot.documents {
            guard var challengeData = try? document.data(as: Challenge.self)
            else { continue }
            challengeData.id = document.documentID
            challenges.append(challengeData)
        }
        filterChallenges()
    }

    private func filterChallenges() {
        userParticipatingChallenges = challenges.filter {
            $0.participants.contains(
                where: { $0.userID == self.authenticationService.currentUser?.id})
        }

        userCurrentChallenge = userParticipatingChallenges.first { $0.date.addingTimeInterval(TimeInterval($0.duration)) > Date.now }

        userCreatedChallenges = challenges.filter {
            $0.creatorUserID == self.authenticationService.currentUser?.id
        }
        otherChallenges = challenges.filter {
            $0.creatorUserID != self.authenticationService.currentUser?.id &&
            !$0.participants.contains(where: { $0.userID == self.authenticationService.currentUser?.id })
        }
    }

    func participateToChallenge(_ challenge: Challenge, user: User) async {
        do {
            try await editChallenge(challenge.addParticipant(user), forUser: user)
        } catch {
            // display error
        }
        await fetchChallenges(forUser: user)
    }

    func areChallengeDatesValid(from startDate: Date, to endDate: Date) -> Bool {
        let challengesToCheck = userParticipatingChallenges
        // Loop through user participating challenges and check if an end date is colliding with a start date
        // Take new challenge start date and is should NOT be contained within another challenge start date and end date
        var isColliding: Bool = false
        challengesToCheck.forEach {
            if startDate >= $0.date && startDate <= $0.date.addingTimeInterval(TimeInterval($0.duration)) {
                isColliding = true
            }
        }
        // Take new challenge end date and is should NOT be contained within another challenge start date and end date
        challengesToCheck.forEach {
            if endDate >= $0.date && endDate <= $0.date.addingTimeInterval(TimeInterval($0.duration)) {
                isColliding = true
            }
        }

        return !isColliding
    }

    private let challengesCollection = Firestore.firestore().collection("challenges")
}
