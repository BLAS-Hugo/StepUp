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

    private var userSessionId: String {
        authenticationService.currentUserSession?.uid ?? ""
    }

    private func createdChallengeLink(challenge: Challenge) -> some View {
        return NavigationLink {
            ChallengeDetailScreen(challenge: challenge)
                .navigationTitle(Text(challenge.name))
                .navigationBarTitleDisplayMode(.large)
        } label: {
            ChallengeCard(
                challenge: challenge,
                userID: userSessionId
            )
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                HStack {
                    Text(LocalizedStringKey("participate_to_other_challenges"))
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SeeMoreButton(
                        title: LocalizedStringKey("challenges"),
                        challenges: challengesService.otherChallenges
                    )
                        .environmentObject(authenticationService)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 16) {
                        ForEach(0..<min(3, challengesService.otherChallenges.count), id: \.self) { index in
                            let challenge = challengesService.otherChallenges[index]
                            createdChallengeLink(challenge: challenge)
                        }
                    }
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(LocalizedStringKey("already_participating"))
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SeeMoreButton(
                        title: LocalizedStringKey("challenges"),
                        challenges: challengesService.userParticipatingChallenges
                    )
                        .environmentObject(authenticationService)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 16) {
                        ForEach(0..<min(3, challengesService.userParticipatingChallenges.count), id: \.self) { index in
                            let challenge = challengesService.userParticipatingChallenges[index]
                            createdChallengeLink(challenge: challenge)
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(alignment: .top)
        .padding(.all, 16)
    }
}
