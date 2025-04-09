//
//  HomeScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    @EnvironmentObject var challengesService: UserChallengesService

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                CircularProgressView()
                CircularProgressView(color: Color.primaryOrange)
            }
            VStack {
                Text("My challenges")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 10) {
                        ForEach(0..<min(3, challengesService.userParticipatingChallenges.count), id: \.self) { index in
                            ChallengeCard(
                                challenge: challengesService.userParticipatingChallenges[index],
                                userID: authenticationService.currentUser!.id
                                )
                        }
                        Button {
                            // Action for See more button
                            Task {
                                await challengesService.fetchChallenges(forUser: authenticationService.currentUser)
                            }
                        } label: {
                            Text("See more")
                        }
                        .padding()
                        .background(Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 16)
                    }
                }
            }
            VStack {
                Text(LocalizedStringKey("current_challenge"))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                if let currentChallenge = challengesService.userParticipatingChallenges.first {
                    Button {
                        // Action for challenge button
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(currentChallenge.name)
                                .font(.title2)
                            if let steps = currentChallenge.goal.steps {
                                let progress = Double(
                                    currentChallenge.getParticipantProgress(
                                        userID: authenticationService.currentUser?.id ?? ""
                                        )
                                    )
                                ProgressView(value: progress, total: Double(steps))
                                    .progressViewStyle(LinearProgressStyle())
                            }
                            let remainingTime = currentChallenge.date.addingTimeInterval(
                                Double(currentChallenge.duration)).timeIntervalSince(Date.now)
                            let remainingDays = Int(remainingTime / 86400)
                            Text("Se termine dans \(remainingDays) jours")
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.all, 8)
                    }
                    .frame(width: UIScreen.main.bounds.size.width * 0.7, height: 118, alignment: .topLeading)
                    .background(Color.primaryOrange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                } else {
                    Button {
                        Task {
                            await authenticationService.fetchUserData()
                            await challengesService.fetchChallenges(forUser: authenticationService.currentUser)
                        }
                        // Action to create a new challenge
                    } label: {
                        VStack(alignment: .center, spacing: 10) {
                            Text("Pas de challenge actif")
                                .font(.title2)
                            Text("Créez un challenge")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.all, 8)
                    }
                    .frame(width: UIScreen.main.bounds.size.width * 0.7, height: 152)
                    .background(Color.gray.opacity(0.2))
                    .foregroundStyle(Color.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.vertical, 24)
    }
}

#Preview {
    return HomeScreen()
}
