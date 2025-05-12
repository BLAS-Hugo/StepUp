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
        && challenge.endDate < Date.now
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
            CircularProgressView(progress: progress, type: challenge.goal.steps != nil ? .steps : .distance, goal: challenge.goal.getGoal())
            Text(challenge.description)
                .frame(alignment: .leading)
            let remainingTime = challenge.date.addingTimeInterval(
                Double(challenge.duration)).timeIntervalSince(Date.now)
            let remainingDays = Int(remainingTime / 86400)
            if remainingDays < 0 {
                Text("Terminé depuis \(remainingDays * -1) jours")
                    .frame(alignment: .leading)
            } else {
                Text("Se termine dans \(remainingDays) jours")
                    .frame(alignment: .leading)
            }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Classement des participants")
                        .font(.title3)
                    ForEach(0..<challenge.participants.count, id: \.self) { index in
                        let participant = challenge.participants[index]
                        HStack {
                            Text(participant.name)
                                .frame(minWidth: 56, alignment: .leading)
                            ProgressView(value: Double(challenge.getParticipantProgress(userID: participant.userID)), total: Double(challenge.goal.getGoal()))
                                .progressViewStyle(LinearProgressStyle())
                                .padding(.horizontal, 4)
                            Text("\(participant.progress)")
                                .frame(minWidth: 56, alignment: .trailing)
                        }
                    }
                    Text("\(challenge.participants.count) participant\(challenge.participants.count > 1 ? "s" : "")")
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
                        await challengesService.participateToChallenge(challenge, user: authenticationService.currentUser!)
                    }
                } label: {
                    Text("Participer")
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
