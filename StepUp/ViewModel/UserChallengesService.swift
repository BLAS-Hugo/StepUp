//
//  UserChallengesService.swift
//  StepUp
//
//  Created by Hugo Blas on 24/03/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

@MainActor
class UserChallengesService: ObservableObject {
    let authenticationService: AuthenticationService

    @Published var challenges: [Challenge] = []
    @Published var userCreatedChallenges: [Challenge] = []
    @Published var userParticipatingChallenges: [Challenge] = []
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
        if user == nil {
            return
        }
        let encodedChallenge = try Firestore.Encoder().encode(challenge)
        try await challengesCollection.document(challenge.id).setData(encodedChallenge)
        await fetchChallenges(forUser: user)
    }

    func deleteChallenge(_ challenge: Challenge, forUser user: User?) async throws {
        if user == nil {
            return
        }
        try await challengesCollection.document(challenge.id).delete()
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
            guard let challengeData = try? document.data(as: Challenge.self)
            else { continue }
            challenges.append(challengeData)
        }
        print(challenges)
        filterChallenges()
    }

    private func filterChallenges() {
        userParticipatingChallenges = challenges.filter {
            $0.participants.contains(
                where: { $0.userID == self.authenticationService.currentUser?.id})
        }
        userCreatedChallenges = challenges.filter {
            $0.creatorUserID == self.authenticationService.currentUser?.id
        }
        otherChallenges = challenges.filter {
            $0.creatorUserID != self.authenticationService.currentUser?.id &&
            !$0.participants.contains(where: { $0.userID == self.authenticationService.currentUser?.id })
        }
    }

    private let challengesCollection = Firestore.firestore().collection("challenges")
}
