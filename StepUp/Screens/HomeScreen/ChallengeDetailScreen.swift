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

    var progress: Int {
        challenge.getParticipantProgress(userID: authenticationService.currentUser!.id)
    }

    var body: some View {
        VStack {
            CircularProgressView(progress: progress, type: challenge.goal.steps != nil ? .steps : .distance, goal: challenge.goal.getGoal())
            Text(challenge.description)
            let remainingTime = challenge.date.addingTimeInterval(
                Double(challenge.duration)).timeIntervalSince(Date.now)
            let remainingDays = Int(remainingTime / 86400)
            if remainingDays < 0 {
                Text("Terminé depuis \(remainingDays * -1) jours")
            } else {
                Text("Se termine dans \(remainingDays) jours")
            }
            // Classement des participants
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(0..<challenge.participants.count, id: \.self) { index in
                        let participant = challenge.participants[index]
                        HStack {
                            Text(participant.name)
                            ProgressView(value: Double(challenge.getParticipantProgress(userID: authenticationService.currentUser!.id)), total: Double(challenge.goal.getGoal()))
                                .progressViewStyle(LinearProgressStyle())
                            Text("\(participant.progress)")
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 16)
            }
            .background(Color.veryLightOrange)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}
