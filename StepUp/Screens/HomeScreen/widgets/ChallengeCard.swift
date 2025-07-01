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
                    .scaledToFit()
                    .foregroundStyle(.black)
                if isUserParticipating {
                    if let progress {
                        ProgressView(
                            value: Double(min(progress, challenge.goal.getGoal())),
                            total: Double(challenge.goal.getGoal())
                        )
                        .progressViewStyle(LinearProgressStyle())
                    }
                }
                Text(challenge.goal.getGoalForDisplay())
                    .foregroundStyle(.black)
                    .font(.body)
                    .scaledToFill()
                Text(
                    challenge.date,
                    format: .dateTime.day().month().year())
                .foregroundStyle(.black)
                .font(.body)
                .scaledToFill()
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

    private var progress: Int? {
        challenge.getParticipantProgress(userID: userID)
    }

    private var wideCard: some View {
        VStack {
            HStack {
                VStack(spacing: 16) {
                    Text(challenge.name)
                        .bold()
                        .foregroundStyle(.black)
                    if isUserParticipating {
                        if let progress {
                            ProgressView(
                                value: Double(
                                    min(
                                        progress,
                                        challenge.goal.getGoal()
                                    )
                                ),
                                total: Double(challenge.goal.getGoal())
                            )
                            .progressViewStyle(LinearProgressStyle())
                        }
                    }
                    Text(challenge.goal.getGoalForDisplay())
                        .foregroundStyle(.black)
                    Text(
                        challenge.date,
                        format: .dateTime.day().month().year())
                    .foregroundStyle(.black)
                }
                .padding(.all, 8)
                if !isUserParticipating {
                    Spacer()
                    VStack(spacing: 8) {
                        Text(LocalizedStringKey("participate_to_challenge"))
                            .bold()
                            .foregroundStyle(.black)
                        ForEach(0..<min(challenge.participants.count, 3), id: \.self) { index in
                            let participant = challenge.participants[index]
                            Text(participant.name)
                                .foregroundStyle(.black)
                        }
                        if challenge.participants.count == 0 {
                            Spacer()
                        }
                    }
                    .frame(alignment: .top)
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 128,
            maxHeight: 128,
            alignment: .topLeading
        )
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal, 8)
    }
}

enum CardViewStyle {
    case original, wide
}
