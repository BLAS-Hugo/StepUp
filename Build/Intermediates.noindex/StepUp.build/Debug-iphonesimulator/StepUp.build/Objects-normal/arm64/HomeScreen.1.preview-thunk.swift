import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Volumes/SSD Mac/Dev/Open Classroom/projet libre/StepUp/StepUp/Screens/HomeScreen/HomeScreen.swift", line: 1)
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
        VStack(spacing: __designTimeInteger("#5756_0", fallback: 16)) {
            HStack {
                CircularProgressView()
                CircularProgressView(color: Color.primaryOrange)
            }
            VStack {
                Text(__designTimeString("#5756_1", fallback: "My challenges"))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, __designTimeInteger("#5756_2", fallback: 16))
                ScrollView(.horizontal, showsIndicators: __designTimeBoolean("#5756_3", fallback: false)) {
                    LazyHStack(alignment: .top, spacing: __designTimeInteger("#5756_4", fallback: 10)) {
                        ForEach(challengesService.userParticipatingChallenges) { challenge in
                            ChallengeCard(challenge: challenge)
                        }
                        Button {
                            // Action for See more button
                        } label: {
                            Text(__designTimeString("#5756_5", fallback: "See more"))
                        }
                        .padding()
                        .background(Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#5756_6", fallback: 18)))
                        .padding(.horizontal, __designTimeInteger("#5756_7", fallback: 16))
                    }
                }
            }
            VStack {
                Text(LocalizedStringKey(__designTimeString("#5756_8", fallback: "current_challenge")))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, __designTimeInteger("#5756_9", fallback: 16))
                if let currentChallenge = challengesService.userParticipatingChallenges.first {
                    Button {
                        // Action for challenge button
                    } label: {
                        VStack(alignment: .leading, spacing: __designTimeInteger("#5756_10", fallback: 10)) {
                            Text(currentChallenge.name)
                                .font(.title2)
                            if let steps = currentChallenge.goal.steps {
                                let progress = Double(
                                    currentChallenge.getParticipantProgress(
                                        userID: authenticationService.currentUser?.id ?? __designTimeString("#5756_11", fallback: "")
                                        )
                                    )
                                ProgressView(value: progress, total: Double(steps))
                                    .progressViewStyle(LinearProgressStyle())
                            }
                            let remainingTime = currentChallenge.date.addingTimeInterval(Double(currentChallenge.duration)).timeIntervalSince(Date.now)
                            let remainingDays = Int(remainingTime / __designTimeInteger("#5756_12", fallback: 86400))
                            Text("Se termine dans \(remainingDays) jours")
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.all, __designTimeInteger("#5756_13", fallback: 8))
                    }
                    .frame(width: UIScreen.main.bounds.size.width * __designTimeFloat("#5756_14", fallback: 0.7), height: __designTimeInteger("#5756_15", fallback: 152), alignment: .topLeading)
                    .background(Color.primaryOrange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#5756_16", fallback: 18)))
                } else {
                    Button {
                        // Action to create a new challenge
                    } label: {
                        VStack(alignment: .center, spacing: __designTimeInteger("#5756_17", fallback: 10)) {
                            Text(__designTimeString("#5756_18", fallback: "No active challenge"))
                                .font(.title2)
                            Text(__designTimeString("#5756_19", fallback: "Create one now"))
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.all, __designTimeInteger("#5756_20", fallback: 8))
                    }
                    .frame(width: UIScreen.main.bounds.size.width * __designTimeFloat("#5756_21", fallback: 0.7), height: __designTimeInteger("#5756_22", fallback: 152))
                    .background(Color.gray.opacity(__designTimeFloat("#5756_23", fallback: 0.2)))
                    .foregroundStyle(Color.primary)
                    .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#5756_24", fallback: 18)))
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    return HomeScreen()
}
