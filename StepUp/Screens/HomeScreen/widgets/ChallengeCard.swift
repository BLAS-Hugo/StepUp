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
    var style: CardViewStyle = .original

    private var isUserParticipating: Bool {
        return challenge.participants.count(where: { $0.userID == userID }) > 0
    }

    var body: some View {
        if style == .original {
            originalCard
        } else {
            wideCard
        }
    }

    private var originalCard: some View {
        VStack {
            VStack(spacing: 16) {
                Text(challenge.name)
                    .bold()
                    .foregroundStyle(.black)
                if isUserParticipating {
                    ProgressView(
                        value: Double(challenge.getParticipantProgress(userID: userID)),
                        total: Double(challenge.goal.getGoal())
                    )
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
    }

    private var wideCard: some View {
        VStack {
            VStack(spacing: 16) {
                Text(challenge.name)
                    .bold()
                    .foregroundStyle(.black)
                if isUserParticipating {
                    ProgressView(
                        value: Double(challenge.getParticipantProgress(userID: userID)),
                        total: Double(challenge.goal.getGoal())
                    )
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
            maxWidth: .infinity,
            minHeight: 128,
            maxHeight: 128,
            alignment: .topLeading
        )
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal, 16)
    }
}

enum CardViewStyle {
    case original, wide
}
