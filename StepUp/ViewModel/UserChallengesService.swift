//
//  UserChallengesService.swift
//  StepUp
//
//  Created by Hugo Blas on 24/03/2025.
//

import FirebaseCore
import FirebaseFirestore
import HealthKit

@MainActor
class UserChallengesService: ObservableObject {
    let authenticationService: AuthenticationService
    let healthKitService: HealthKitService
    private var timer: Timer?

    @Published var challenges: [Challenge] = []
    @Published var userCreatedChallenges: [Challenge] = []
    @Published var userParticipatingChallenges: [Challenge] = []
    @Published var userCurrentChallenge: Challenge?
    @Published var otherChallenges: [Challenge] = []
    @Published var userChallengesHistory: [Challenge] = []

    init(with authenticationService: AuthenticationService, _ healthKitService: HealthKitService) {
        self.authenticationService = authenticationService
        self.healthKitService = healthKitService
        if self.authenticationService.currentUser == nil {
            return
        }
        Task {
            await fetchChallenges(forUser: self.authenticationService.currentUser)
            await updateUserCurrentChallenge()
            startUpdateTimer()
        }
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }

    private func startUpdateTimer() {
        stopUpdateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.updateUserCurrentChallenge()
            }
        }
    }

    private func stopUpdateTimer() {
        timer?.invalidate()
        timer = nil
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
                where: { $0.userID == self.authenticationService.currentUser?.id}) && $0.endDate > Date.now
        }

        userCurrentChallenge = userParticipatingChallenges.first { $0.endDate > Date.now }

        userCreatedChallenges = challenges.filter {
            $0.creatorUserID == self.authenticationService.currentUser?.id && $0.endDate > Date.now
        }
        otherChallenges = challenges.filter {
            $0.creatorUserID != self.authenticationService.currentUser?.id &&
            !$0.participants.contains(where: { $0.userID == self.authenticationService.currentUser?.id }) &&
            $0.endDate > Date.now
        }

        userChallengesHistory = challenges.filter {
            $0.participants.contains(
                where: { $0.userID == self.authenticationService.currentUser?.id}) && $0.endDate < Date.now
        }

        challenges.removeAll(where: {
            $0.endDate < Date.now
        })
    }

    func participateToChallenge(_ challenge: Challenge, user: User) async {
        do {
            try await editChallenge(challenge.addParticipant(user), forUser: user)
        } catch {
            // display error
        }
        await fetchChallenges(forUser: user)
    }

    func updateUserCurrentChallenge() async {
        guard let userCurrentChallenge, let currentUser = authenticationService.currentUser else { return }

        let type = userCurrentChallenge.goal.steps ?? 0 > 0
        ? HKQuantityType.quantityType(forIdentifier: .stepCount)!
        : HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!

        let newProgress = await healthKitService.fetchDataForDatatypeAndDate(
            for: type,
            from: userCurrentChallenge.date,
            to: userCurrentChallenge.endDate
        )

        let currentProgress = userCurrentChallenge.participants.first(
            where: { $0.userID == currentUser.id })?.progress ?? 0

        if newProgress > currentProgress {
            print("Updating challenge progress: \(currentProgress) -> \(newProgress)")
            let updatedChallenge = userCurrentChallenge.editParticipantProgress(
                currentUser,
                progress: newProgress)
            try? await editChallenge(updatedChallenge, forUser: currentUser)
        }
    }

    func areChallengeDatesValid(from startDate: Date, to endDate: Date) -> Bool {
        let challengesToCheck = userParticipatingChallenges

        var isColliding: Bool = false
        challengesToCheck.forEach {
            if startDate >= $0.date && startDate <= $0.endDate {
                isColliding = true
            }
        }

        challengesToCheck.forEach {
            if endDate >= $0.date && endDate <= $0.endDate {
                isColliding = true
            }
        }

        return !isColliding
    }

    private let challengesCollection = Firestore.firestore().collection("challenges")
}
