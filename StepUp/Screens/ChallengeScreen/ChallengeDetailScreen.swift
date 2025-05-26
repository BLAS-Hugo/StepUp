//
//  ChallengeDetailScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 11/04/2025.
//

import SwiftUI

struct ChallengeDetailScreen: View {
    var challenge: Challenge
    @EnvironmentObject var authenticationService: AuthenticationViewModel
    @EnvironmentObject var challengesService: UserChallengesService

    @State private var showParticipateAlert: Bool = false

    private var canParticipate: Bool {
        return challenge.participants.count(where: { $0.userID == authenticationService.currentUser!.id }) < 1
        && challenge.endDate > Date.now
        && challengesService.areChallengeDatesValid(from: challenge.date, to: challenge.endDate)
    }

    private var isParticipating: Bool {
        return challenge.participants.count(where: { $0.userID == authenticationService.currentUser!.id }) > 0
    }

    var progress: Int {
        if isParticipating {
            return challenge.getParticipantProgress(userID: authenticationService.currentUser!.id) ?? 0
        }
        return 0
    }

    var body: some View {
        VStack(spacing: 8) {
            CircularProgressView(
                progress: min(progress, challenge.goal.getGoal()),
                type: challenge.goal.steps != nil ? .steps : .distance, goal: challenge.goal.getGoal())
            Text(challenge.description)
                .frame(alignment: .leading)
            let remainingTime = challenge.date.addingTimeInterval(
                Double(challenge.duration)).timeIntervalSince(Date.now)
            let remainingDays = Int(remainingTime / 86400)
            if remainingDays < 0 {
                Text("Ended since \(remainingDays * -1) day")
                    .frame(alignment: .leading)
            } else {
                Text("Ends in \(remainingDays) day")
                    .frame(alignment: .leading)
            }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(LocalizedStringKey("participant_rankings"))
                            .font(.title3)
                        Spacer()
                    }
                    ForEach(0..<challenge.participants.count, id: \.self) { index in
                        let sortedParticipant = challenge.participants.sorted { $0.progress > $1.progress }
                        let participant = sortedParticipant[index]

                        HStack {
                            Text(participant.name)
                                .frame(minWidth: 56, alignment: .leading)
                            ProgressView(
                                value: Double(
                                    min(challenge.getParticipantProgress(userID: participant.userID) ?? 0,
                                        challenge.goal.getGoal())),
                                total: Double(challenge.goal.getGoal()))
                                .progressViewStyle(LinearProgressStyle())
                                .padding(.horizontal, 4)
                            Text("\(participant.progress / (challenge.goal.steps ?? 0 > 0 ? 1 : 1000))")
                                .frame(minWidth: 56, alignment: .trailing)
                        }
                    }
                    Text(
                        "\(challenge.participants.count) participant")
                        .bold()
                        .frame(alignment: .bottom)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 16)
            }
            .background(Color.appLightGray)
            .clipShape(RoundedRectangle(cornerRadius: 18))

            if canParticipate {
                Button {
                    Task {
                        do {
                            try await challengesService.participateToChallenge(
                                challenge, user: authenticationService.currentUser!)
                        } catch {
                            showParticipateAlert.toggle()
                        }
                    }
                } label: {
                    Text(LocalizedStringKey("participate"))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 48)
                        .foregroundStyle(.white)
                }
                .frame(minWidth: 135, minHeight: 64, alignment: .center)
                .background(Color.primaryOrange)
                .clipShape(.rect(cornerRadius: 8))
            }
        }
        .padding(.horizontal, 16)
        .alert(LocalizedStringKey("network_error"), isPresented: $showParticipateAlert) {
            Button("OK", role: .cancel) {
                showParticipateAlert.toggle()
            }
        } message: {
            Text(LocalizedStringKey("network_error_message"))
        }
    }
}
