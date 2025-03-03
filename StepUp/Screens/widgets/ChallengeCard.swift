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
            VStack {
                Text(challenge.name)
                    .font(.title2)
                    .foregroundStyle(.black)
                Text(challenge.description)
                    .padding(.vertical, 4)
                    .lineLimit(7)
                    .foregroundStyle(.black)
                ProgressView(value: Double(challenge.getParticipantProgress(userID: "123")), total: Double(challenge.goal.getGoal()))
                    .progressViewStyle(LinearProgressStyle())
                Text(challenge.goal.getGoalForDisplay())
                    .foregroundStyle(.black)
            }
            .frame(maxHeight: 256, alignment: .top)
        }
        .padding()
        .frame(width: 128, height: 256)
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.leading, 16)
    }
}

#Preview {
    HomeScreen()
}
