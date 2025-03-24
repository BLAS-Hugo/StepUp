//
//  ChallengeCard.swift
//  StepUp
//
//  Created by Hugo Blas on 24/02/2025.
//

import SwiftUI

struct ChallengeCard: View {
    var challenge: Challenge

    var body : some View {
        Button {
            print("\(challenge.name) was tapped")
        } label: {
            VStack(spacing: 16) {
                Text(challenge.name)
                    .font(.title2)
                    .foregroundStyle(.black)
                ProgressView(value: Double(challenge.getParticipantProgress(userID: "123")), total: Double(challenge.goal.getGoal()))
                    .progressViewStyle(LinearProgressStyle())
                Text(challenge.goal.getGoalForDisplay())
                    .foregroundStyle(.black)
                Text(
                    challenge.date,
                    format: .dateTime.day().month().year())
                    .foregroundStyle(.black)
            }
            .padding()
            .frame(alignment: .top)
        }
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.leading, 16)
        .frame(maxWidth: 156, maxHeight: 200)
    }
}

#Preview {
    HomeScreen()
}
