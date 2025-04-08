import func SwiftUI.__designTimeSelection

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
        __designTimeSelection(VStack(spacing: __designTimeInteger("#12867_0", fallback: 16)) {
            __designTimeSelection(HStack {
                __designTimeSelection(CircularProgressView(), "#12867.[1].[2].property.[0].[0].arg[1].value.[0].arg[0].value.[0]")
                __designTimeSelection(CircularProgressView(color: __designTimeSelection(Color.primaryOrange, "#12867.[1].[2].property.[0].[0].arg[1].value.[0].arg[0].value.[1].arg[0].value")), "#12867.[1].[2].property.[0].[0].arg[1].value.[0].arg[0].value.[1]")
            }, "#12867.[1].[2].property.[0].[0].arg[1].value.[0]")
            __designTimeSelection(VStack {
                __designTimeSelection(Text(__designTimeString("#12867_1", fallback: "My challenges"))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, __designTimeInteger("#12867_2", fallback: 16)), "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[0]")
                __designTimeSelection(ScrollView(.horizontal, showsIndicators: __designTimeBoolean("#12867_3", fallback: false)) {
                    __designTimeSelection(LazyHStack(alignment: .top, spacing: __designTimeInteger("#12867_4", fallback: 10)) {
                        __designTimeSelection(ForEach(__designTimeSelection(challengesService.userParticipatingChallenges, "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[0].arg[0].value")) { challenge in
                            __designTimeSelection(ChallengeCard(challenge: __designTimeSelection(challenge, "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[0].arg[1].value.[0].arg[0].value")), "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[0].arg[1].value.[0]")
                        }, "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[0]")
                        __designTimeSelection(Button {
                            // Action for See more button
                            __designTimeSelection(Task {
                                await __designTimeSelection(challengesService.fetchChallenges(forUser: __designTimeSelection(authenticationService.currentUser, "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[1].arg[0].value.[0].arg[0].value.[0].modifier[0].arg[0].value")), "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[1].arg[0].value.[0].arg[0].value.[0]")
                            }, "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[1].arg[0].value.[0]")
                        } label: {
                            __designTimeSelection(Text(__designTimeString("#12867_5", fallback: "See more")), "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[1].arg[1].value.[0]")
                        }
                        .padding()
                        .background(__designTimeSelection(Color(.systemFill), "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[1].modifier[1].arg[0].value"))
                        .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#12867_6", fallback: 18)), "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[1].modifier[2].arg[0].value"))
                        .padding(.horizontal, __designTimeInteger("#12867_7", fallback: 16)), "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[1]")
                    }, "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0]")
                }, "#12867.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1]")
            }, "#12867.[1].[2].property.[0].[0].arg[1].value.[1]")
            __designTimeSelection(VStack {
                __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#12867_8", fallback: "current_challenge")), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[0].arg[0].value"))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, __designTimeInteger("#12867_9", fallback: 16)), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[0]")
                if let currentChallenge = challengesService.userParticipatingChallenges.first {
                    __designTimeSelection(Button {
                        // Action for challenge button
                    } label: {
                        __designTimeSelection(VStack(alignment: .leading, spacing: __designTimeInteger("#12867_10", fallback: 10)) {
                            __designTimeSelection(Text(__designTimeSelection(currentChallenge.name, "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[0].arg[0].value"))
                                .font(.title2), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[0]")
                            if let steps = currentChallenge.goal.steps {
                                let progress = Double(
                                    __designTimeSelection(currentChallenge.getParticipantProgress(
                                        userID: authenticationService.currentUser?.id ?? __designTimeString("#12867_11", fallback: "")
                                        ), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[1].[0].[0].value.arg[0].value")
                                    )
                                __designTimeSelection(ProgressView(value: __designTimeSelection(progress, "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[1].[0].[1].arg[0].value"), total: __designTimeSelection(Double(__designTimeSelection(steps, "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[1].[0].[1].arg[1].value.arg[0].value")), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[1].[0].[1].arg[1].value"))
                                    .progressViewStyle(__designTimeSelection(LinearProgressStyle(), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[1].[0].[1].modifier[0].arg[0].value")), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[1].[0].[1]")
                            }
                            let remainingTime = currentChallenge.date.addingTimeInterval(__designTimeSelection(Double(__designTimeSelection(currentChallenge.duration, "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[2].value.modifier[0].arg[0].value.arg[0].value")), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[2].value.modifier[0].arg[0].value")).timeIntervalSince(__designTimeSelection(Date.now, "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[2].value.modifier[1].arg[0].value"))
                            let remainingDays = Int(remainingTime / __designTimeInteger("#12867_12", fallback: 86400))
                            __designTimeSelection(Text("Se termine dans \(__designTimeSelection(remainingDays, "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[4].arg[0].value.[1].value.arg[0].value")) jours"), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[4]")
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.all, __designTimeInteger("#12867_13", fallback: 8)), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0]")
                    }
                    .frame(width: UIScreen.main.bounds.size.width * __designTimeFloat("#12867_14", fallback: 0.7), height: __designTimeInteger("#12867_15", fallback: 152), alignment: .topLeading)
                    .background(__designTimeSelection(Color.primaryOrange, "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].modifier[1].arg[0].value"))
                    .foregroundStyle(.white)
                    .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#12867_16", fallback: 18)), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].modifier[3].arg[0].value")), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0]")
                } else {
                    __designTimeSelection(Button {
                        // Action to create a new challenge
                    } label: {
                        __designTimeSelection(VStack(alignment: .center, spacing: __designTimeInteger("#12867_17", fallback: 10)) {
                            __designTimeSelection(Text(__designTimeString("#12867_18", fallback: "Pas de challenge actif"))
                                .font(.title2), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0].arg[1].value.[0].arg[2].value.[0]")
                            __designTimeSelection(Text(__designTimeString("#12867_19", fallback: "Créez un challenge"))
                                .font(.subheadline), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0].arg[1].value.[0].arg[2].value.[1]")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.all, __designTimeInteger("#12867_20", fallback: 8)), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0].arg[1].value.[0]")
                    }
                    .frame(width: UIScreen.main.bounds.size.width * __designTimeFloat("#12867_21", fallback: 0.7), height: __designTimeInteger("#12867_22", fallback: 152))
                    .background(__designTimeSelection(Color.gray.opacity(__designTimeFloat("#12867_23", fallback: 0.2)), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0].modifier[1].arg[0].value"))
                    .foregroundStyle(__designTimeSelection(Color.primary, "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0].modifier[2].arg[0].value"))
                    .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#12867_24", fallback: 18)), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0].modifier[3].arg[0].value")), "#12867.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0]")
                }
            }, "#12867.[1].[2].property.[0].[0].arg[1].value.[2]")
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.vertical, __designTimeInteger("#12867_25", fallback: 24)), "#12867.[1].[2].property.[0].[0]")
    }
}

#Preview {
    return HomeScreen()
}
