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
            VStack (alignment: .leading) {
                HStack {
                    Text("Participez aux challenges des autres utilisateurs")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SeeMoreButton(title: "Challenges", challenges: challengesService.otherChallenges)
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
            VStack (alignment: .leading) {
                HStack {
                    Text("Vous y participez déjà")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SeeMoreButton(title: "Challenges", challenges: challengesService.userParticipatingChallenges)
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
//                    ForEach(0..<challengesService.otherChallenges.count, id: \.self) { index in
//                        let challenge = challengesService.otherChallenges[index]
//                        NavigationLink {
//                            ChallengeDetailScreen(challenge: challengesService.otherChallenges[index])
//                                .navigationTitle(Text(challengesService.otherChallenges[index].name))
//                                .navigationBarTitleDisplayMode(.large)
//                        } label: {
//                            VStack(spacing: 4) {
//                                Text(challenge.name)
//                                    .bold()
//                                    .foregroundStyle(.black)
//                                Text(challenge.goal.getGoalForDisplay())
//                                    .foregroundStyle(.black)
//                                Text(
//                                    challenge.date,
//                                    format: .dateTime.day().month().year())
//                                .foregroundStyle(.black)
//                            }
//                            .frame(height: 96)
//                            .padding(.all, 8)
//                            .background(Color(.systemFill))
//                            .clipShape(RoundedRectangle(cornerRadius: 18))
//                            .padding(.leading, 16)
//                        }
//                    }
                }
        .frame(alignment: .top)
        .padding(.all, 16)
    }
}
