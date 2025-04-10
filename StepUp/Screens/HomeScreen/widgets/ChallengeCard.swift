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

    var body : some View {
        Button {
            let progress = challenge.getParticipantProgress(userID: userID)
            print("\(challenge.name) was tapped with progress \(progress)/\(challenge.goal.getGoal())")
        } label: {
            VStack(spacing: 16) {
                Text(challenge.name)
                    .font(.title3)
                    .foregroundStyle(.black)
                ProgressView(value: Double(challenge.getParticipantProgress(userID: userID)), total: Double(challenge.goal.getGoal()))
                    .progressViewStyle(LinearProgressStyle())
                Text(challenge.goal.getGoalForDisplay())
                    .foregroundStyle(.black)
                Text(
                    challenge.date,
                    format: .dateTime.day().month().year())
                    .foregroundStyle(.black)
            }
            .padding()
            .frame(alignment: .topLeading)
        }
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.leading, 16)
        .frame(maxWidth: 156, maxHeight: 200)
    }
}

#Preview {
    let authenticationService = AuthenticationService()
    let challengesService = UserChallengesService(authenticationService: authenticationService)

    HomeScreen()
        .environmentObject(challengesService)
        .environmentObject(authenticationService)
}
