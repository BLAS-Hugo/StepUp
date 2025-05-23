//
//  HomeScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var authenticationService: FirebaseAuthProvider
    @EnvironmentObject var challengesService: UserChallengesService
    @EnvironmentObject var healthKitService: HealthKitService
    @EnvironmentObject var goalViewModel: GoalViewModel

    @State private var shouldShowChallengesSheet = false

    private var userId: String {
        authenticationService.currentUser?.id ?? ""
    }

    private var userSessionId: String {
        authenticationService.currentUserSession?.uid ?? ""
    }

    private func challengeProgress(for challenge: Challenge) -> Int? {
        challenge.getParticipantProgress(userID: userId)
    }

    private func challengeRemainingDays(for challenge: Challenge) -> Int {
        let endDate = challenge.date.addingTimeInterval(Double(challenge.duration))
        let remainingTime = endDate.timeIntervalSince(Date.now)
        return Int(remainingTime / 86400)
    }

    private func challengeTimeText(remainingDays: Int) -> Text {
        if remainingDays < 0 {
            return Text("Ended since \(remainingDays * -1) day")
        } else {
            return Text("Ends in \(remainingDays) day")
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                CircularProgressView(
                    progress: healthKitService.stepCount,
                    goal: goalViewModel.numberOfSteps
                )
                CircularProgressView(
                    color: Color.primaryOrange,
                    progress: healthKitService.distance,
                    type: .distance,
                    goal: goalViewModel.distance
                )
            }

            challengesSection
            currentChallengeSection
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.all, 16)
    }

    private var challengesSection: some View {
        VStack {
            HStack {
                Text(LocalizedStringKey("my_challenges"))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                SeeMoreButton(
                    title: LocalizedStringKey("my_challenges"),
                    challenges: challengesService.userCreatedChallenges
                )
                .environmentObject(authenticationService)
            }
            .padding(.horizontal, 16)
            if challengesService.userCreatedChallenges.count > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 16) {
                        ForEach(0..<min(3, challengesService.userCreatedChallenges.count), id: \.self) { index in
                            createdChallengeLink(index: index)
                        }
                    }
                }
            } else {
                Text(LocalizedStringKey("no_current_challenge"))
                    .padding(.vertical, 16)
            }
        }
    }

    private func createdChallengeLink(index: Int) -> some View {
        let challenge = challengesService.userCreatedChallenges[index]

        return NavigationLink {
            ChallengeDetailScreen(challenge: challenge)
                .navigationTitle(Text(challenge.name))
                .navigationBarTitleDisplayMode(.large)
        } label: {
            ChallengeCard(
                challenge: challenge,
                userID: userSessionId
            )
        }
    }

    private var currentChallengeSection: some View {
        VStack {
            Text(LocalizedStringKey("current_challenge"))
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)

            if let currentChallenge = challengesService.userCurrentChallenge {
                currentChallengeView(challenge: currentChallenge)
            } else {
                noChallengeView
            }
        }
    }

    private func currentChallengeView(challenge: Challenge) -> some View {
        NavigationLink {
            ChallengeDetailScreen(challenge: challenge)
                .navigationTitle(Text(challenge.name))
                .navigationBarTitleDisplayMode(.large)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Text(challenge.name)
                    .font(.title2)

                let progress = challengeProgress(for: challenge)
                if let progress {
                    ProgressView(
                        value: min(Double(progress), Double(challenge.goal.getGoal())),
                        total: Double(challenge.goal.getGoal()))
                    .progressViewStyle(LinearProgressStyle())
                }

                let remainingDays = challengeRemainingDays(for: challenge)
                challengeTimeText(remainingDays: remainingDays)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.all, 16)
        }
        .frame(width: UIScreen.main.bounds.size.width * 0.8, height: 152, alignment: .topLeading)
        .background(Color.primaryOrange)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func closeBottomSheet() {
        shouldShowChallengesSheet = false
    }

    private var noChallengeView: some View {
        Button {
            shouldShowChallengesSheet.toggle()
        } label: {
            VStack(alignment: .center, spacing: 10) {
                Text(LocalizedStringKey("no_active_challenge"))
                    .font(.title2)
                Text(LocalizedStringKey("create_challenge"))
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity)
            .padding(.all, 8)
        }
        .sheet(isPresented: $shouldShowChallengesSheet) {
            ChallengeCreationSheet(closeCallback: closeBottomSheet)
                .presentationDetents([.large])
                .environmentObject(challengesService)
                .environmentObject(authenticationService)
        }
        .frame(width: UIScreen.main.bounds.size.width * 0.8, height: 152)
        .background(Color.gray.opacity(0.2))
        .foregroundStyle(Color.primary)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
