//
//  ChallengeDetailScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 11/04/2025.
//

import SwiftUI

struct ChallengeDetailScreen: View {
    let challenge: Challenge
    @EnvironmentObject var authenticationService: AuthenticationService
    @EnvironmentObject var challengesService: UserChallengesService

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
            return challenge.getParticipantProgress(userID: authenticationService.currentUser!.id)
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
                Text("\(LocalizedStringKey("ended_since")) \(remainingDays * -1) \(LocalizedStringKey("day"))\(remainingDays > 1 ? "s" : "")")
                    .frame(alignment: .leading)
            } else {
                Text("\(LocalizedStringKey("ends_in")) \(remainingDays) \(LocalizedStringKey("day"))\(remainingDays > 1 ? "s" : "")")
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
                        let participant = challenge.participants[index]
                        HStack {
                            Text(participant.name)
                                .frame(minWidth: 56, alignment: .leading)
                            ProgressView(
                                value: Double(
                                    min(challenge.getParticipantProgress(userID: participant.userID),
                                        challenge.goal.getGoal())),
                                total: Double(challenge.goal.getGoal()))
                                .progressViewStyle(LinearProgressStyle())
                                .padding(.horizontal, 4)
                            Text("\(participant.progress / (challenge.goal.steps ?? 0 > 0 ? 1 : 1000))")
                                .frame(minWidth: 56, alignment: .trailing)
                        }
                    }
                    Text(
                        "\(challenge.participants.count) \(LocalizedStringKey("participant"))\(challenge.participants.count > 1 ? "s":"")")
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
                        await challengesService.participateToChallenge(
                            challenge, user: authenticationService.currentUser!)
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
    }
}
