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
    let authenticationService: AuthenticationViewModel
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
        with authenticationService: AuthenticationViewModel,
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

    func participateToChallenge(_ challenge: Challenge, user: User) async throws {
        do {
            try await editChallenge(challenge.addParticipant(user), forUser: user)
        } catch {
            throw error
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
            if startDate >= challenge.date && startDate < challenge.endDate {
                return false
            }

            if endDate > challenge.date && endDate <= challenge.endDate {
                return false
            }

            if startDate <= challenge.date && endDate >= challenge.endDate {
                return false
            }
        }

        return true
    }

    func updateUserNameInAllChallenges(for user: User, newFirstName: String) async throws {
        let challengesToUpdate = challenges.filter { challenge in
            challenge.participants.contains { $0.userID == user.id }
        }

        for challenge in challengesToUpdate {
            var updatedParticipants = challenge.participants
            if let participantIndex = updatedParticipants.firstIndex(where: { $0.userID == user.id }) {
                let currentParticipant = updatedParticipants[participantIndex]
                updatedParticipants[participantIndex] = Participant(
                    userID: currentParticipant.userID,
                    name: newFirstName,
                    progress: currentParticipant.progress
                )

                let updatedChallenge = Challenge(
                    creatorUserID: challenge.creatorUserID,
                    participants: updatedParticipants,
                    name: challenge.name,
                    description: challenge.description,
                    goal: challenge.goal,
                    duration: challenge.duration,
                    date: challenge.date,
                    id: challenge.id
                )

                try await challengeStore.editChallenge(updatedChallenge)
            }
        }
        await fetchChallenges(forUser: user)
    }
}
