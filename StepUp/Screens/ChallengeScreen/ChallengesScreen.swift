//
//  ChallengesScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 21/03/2025.
//

import SwiftUI

struct ChallengesScreen: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    @EnvironmentObject var challengesService: UserChallengesService

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                    ForEach(0..<challengesService.otherChallenges.count, id: \.self) { index in
                        let challenge = challengesService.otherChallenges[index]
                        NavigationLink {
                            ChallengeDetailScreen(challenge: challengesService.otherChallenges[index])
                                .navigationTitle(Text(challengesService.otherChallenges[index].name))
                                .navigationBarTitleDisplayMode(.large)
                        } label: {
                            VStack(spacing: 4) {
                                Text(challenge.name)
                                    .bold()
                                    .foregroundStyle(.black)
                                Text(challenge.goal.getGoalForDisplay())
                                    .foregroundStyle(.black)
                                Text(
                                    challenge.date,
                                    format: .dateTime.day().month().year())
                                .foregroundStyle(.black)
                            }
                            .frame(height: 96)
                            .padding(.all, 8)
                            .background(Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(.leading, 16)
                        }
                        // .padding(.horizontal, 16)
                    }
                }
        .padding(.all, 16)
    }
}
