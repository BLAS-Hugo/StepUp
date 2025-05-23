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
    let authenticationService: any AuthProviding
    let healthKitService: any HealthKitServiceProtocol
    private let challengeStore: ChallengeStoring
    private var timer: Timer?

    @Published var challenges: [Challenge] = []
    @Published var userCreatedChallenges: [Challenge] = []
    @Published var userParticipatingChallenges: [Challenge] = []
    @Published var userCurrentChallenge: Challenge?
    @Published var otherChallenges: [Challenge] = []
    @Published var userChallengesHistory: [Challenge] = []

    init(
        with authenticationService: any AuthProviding,
        _ healthKitService: any HealthKitServiceProtocol,
        challengeStore: ChallengeStoring) {
        self.authenticationService = authenticationService
        self.healthKitService = healthKitService
        self.challengeStore = challengeStore
        if self.authenticationService.currentUser == nil {
            return
        }
        Task {
            await fetchChallenges(forUser: self.authenticationService.currentUser)
            await updateUserCurrentChallenge(forUser: self.authenticationService.currentUser)
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
                await self?.updateUserCurrentChallenge(forUser: self?.authenticationService.currentUser)
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
        try await challengeStore.createChallenge(challenge)
        await fetchChallenges(forUser: user)
    }

    func editChallenge(_ challenge: Challenge, forUser user: User?) async throws {
        if user == nil || challenge.id == nil {
            return
        }
        try await challengeStore.editChallenge(challenge)
        await fetchChallenges(forUser: user)
    }

    func deleteChallenge(_ challenge: Challenge, forUser user: User?) async throws {
        if user == nil || challenge.id == nil {
            return
        }
        try await challengeStore.deleteChallenge(challenge)
        await fetchChallenges(forUser: user)
    }

    func fetchChallenges(forUser user: User?) async {
        challenges = []
        if user == nil {
            return
        }
        do {
            let fetchedChallenges = try await challengeStore.fetchChallenges()
            self.challenges = fetchedChallenges
        } catch {
            print("Error fetching challenges: \(error)")
        }
        filterChallenges(forUser: user)
    }

    func filterChallenges(forUser user: User? = nil) {
        let currentUser = user ?? self.authenticationService.currentUser

        userParticipatingChallenges = challenges.filter {
            $0.participants.contains(
                where: { $0.userID == currentUser?.id}) && $0.endDate > Date.now
        }.sorted(by: { $0.date < $1.date })
        
        userCurrentChallenge = userParticipatingChallenges.first(
            where: { $0.date <= Date.now && $0.endDate > Date.now })

        if userCurrentChallenge == nil {
            userCurrentChallenge = userParticipatingChallenges.first
        }

        userCreatedChallenges = challenges.filter {
            $0.creatorUserID == currentUser?.id && $0.endDate > Date.now
        }
        
        otherChallenges = challenges.filter {
            $0.creatorUserID != currentUser?.id &&
            !$0.participants.contains(where: { $0.userID == currentUser?.id }) &&
            $0.endDate > Date.now
        }

        userChallengesHistory = challenges.filter {
            $0.participants.contains(
                where: { $0.userID == currentUser?.id}) && $0.endDate < Date.now
        }

        challenges.removeAll(where: {
            $0.endDate < Date.now
        })
    }

    func participateToChallenge(_ challenge: Challenge, user: User) async {
        do {
            try await editChallenge(challenge.addParticipant(user), forUser: user)
        } catch {
            print("Error participating in challenge: \(error)")
        }
    }

    func updateUserCurrentChallenge(forUser user: User? = nil) async {
        let currentUser = user ?? authenticationService.currentUser
        guard let userCurrentChallenge, let currentUser = currentUser else { return }

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
        
        if challengesToCheck.isEmpty {
            return true
        }

        for challenge in challengesToCheck {
            // Case 1: New challenge start date is within an existing challenge
            if startDate >= challenge.date && startDate < challenge.endDate {
                return false
            }
            
            // Case 2: New challenge end date is within an existing challenge
            if endDate > challenge.date && endDate <= challenge.endDate {
                return false
            }
            
            // Case 3: New challenge completely surrounds an existing challenge
            if startDate <= challenge.date && endDate >= challenge.endDate {
                return false
            }
        }

        return true
    }
}
