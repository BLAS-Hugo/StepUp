//
//  ChallengeCard.swift
//  StepUp
//
//  Created by Hugo Blas on 24/02/2025.
//

import SwiftUI

struct ChallengeCard: View {
    var challenge: Challenge
    var userID: String

    private var isUserParticipating: Bool {
        return challenge.participants.count(where: { $0.userID == userID }) > 0
    }

    var body : some View {
        VStack {
            VStack(spacing: 16) {
                Text(challenge.name)
                    .bold()
                    .foregroundStyle(.black)
                if isUserParticipating {
                    ProgressView(value: Double(challenge.getParticipantProgress(userID: userID)), total: Double(challenge.goal.getGoal()))
                        .progressViewStyle(LinearProgressStyle())
                }
                Text(challenge.goal.getGoalForDisplay())
                    .foregroundStyle(.black)
                Text(
                    challenge.date,
                    format: .dateTime.day().month().year())
                .foregroundStyle(.black)
            }
            .padding(.all, 8)
        }
        .frame(
            width: 150,
            height: 128,
            alignment: .topLeading
        )
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.leading, 16)
    }
}
