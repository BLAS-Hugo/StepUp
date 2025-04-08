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
        __designTimeSelection(VStack(spacing: __designTimeInteger("#5756_0", fallback: 16)) {
            __designTimeSelection(HStack {
                __designTimeSelection(CircularProgressView(), "#5756.[1].[2].property.[0].[0].arg[1].value.[0].arg[0].value.[0]")
                __designTimeSelection(CircularProgressView(color: __designTimeSelection(Color.primaryOrange, "#5756.[1].[2].property.[0].[0].arg[1].value.[0].arg[0].value.[1].arg[0].value")), "#5756.[1].[2].property.[0].[0].arg[1].value.[0].arg[0].value.[1]")
            }, "#5756.[1].[2].property.[0].[0].arg[1].value.[0]")
            __designTimeSelection(VStack {
                __designTimeSelection(Text(__designTimeString("#5756_1", fallback: "My challenges"))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, __designTimeInteger("#5756_2", fallback: 16)), "#5756.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[0]")
                __designTimeSelection(ScrollView(.horizontal, showsIndicators: __designTimeBoolean("#5756_3", fallback: false)) {
                    __designTimeSelection(LazyHStack(alignment: .top, spacing: __designTimeInteger("#5756_4", fallback: 10)) {
                        __designTimeSelection(ForEach(__designTimeSelection(challengesService.userParticipatingChallenges, "#5756.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[0].arg[0].value")) { challenge in
                            __designTimeSelection(ChallengeCard(challenge: __designTimeSelection(challenge, "#5756.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[0].arg[1].value.[0].arg[0].value")), "#5756.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[0].arg[1].value.[0]")
                        }, "#5756.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[0]")
                        __designTimeSelection(Button {
                            // Action for See more button
                        } label: {
                            __designTimeSelection(Text(__designTimeString("#5756_5", fallback: "See more")), "#5756.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[1].arg[1].value.[0]")
                        }
                        .padding()
                        .background(__designTimeSelection(Color(.systemFill), "#5756.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[1].modifier[1].arg[0].value"))
                        .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#5756_6", fallback: 18)), "#5756.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[1].modifier[2].arg[0].value"))
                        .padding(.horizontal, __designTimeInteger("#5756_7", fallback: 16)), "#5756.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[2].value.[1]")
                    }, "#5756.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0]")
                }, "#5756.[1].[2].property.[0].[0].arg[1].value.[1].arg[0].value.[1]")
            }, "#5756.[1].[2].property.[0].[0].arg[1].value.[1]")
            __designTimeSelection(VStack {
                __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#5756_8", fallback: "current_challenge")), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[0].arg[0].value"))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, __designTimeInteger("#5756_9", fallback: 16)), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[0]")
                if let currentChallenge = challengesService.userParticipatingChallenges.first {
                    __designTimeSelection(Button {
                        // Action for challenge button
                    } label: {
                        __designTimeSelection(VStack(alignment: .leading, spacing: __designTimeInteger("#5756_10", fallback: 10)) {
                            __designTimeSelection(Text(__designTimeSelection(currentChallenge.name, "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[0].arg[0].value"))
                                .font(.title2), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[0]")
                            if let steps = currentChallenge.goal.steps {
                                let progress = Double(
                                    __designTimeSelection(currentChallenge.getParticipantProgress(
                                        userID: authenticationService.currentUser?.id ?? __designTimeString("#5756_11", fallback: "")
                                        ), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[1].[0].[0].value.arg[0].value")
                                    )
                                __designTimeSelection(ProgressView(value: __designTimeSelection(progress, "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[1].[0].[1].arg[0].value"), total: __designTimeSelection(Double(__designTimeSelection(steps, "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[1].[0].[1].arg[1].value.arg[0].value")), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[1].[0].[1].arg[1].value"))
                                    .progressViewStyle(__designTimeSelection(LinearProgressStyle(), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[1].[0].[1].modifier[0].arg[0].value")), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[1].[0].[1]")
                            }
                            let remainingTime = currentChallenge.date.addingTimeInterval(__designTimeSelection(Double(__designTimeSelection(currentChallenge.duration, "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[2].value.modifier[0].arg[0].value.arg[0].value")), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[2].value.modifier[0].arg[0].value")).timeIntervalSince(__designTimeSelection(Date.now, "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[2].value.modifier[1].arg[0].value"))
                            let remainingDays = Int(remainingTime / __designTimeInteger("#5756_12", fallback: 86400))
                            __designTimeSelection(Text("Se termine dans \(__designTimeSelection(remainingDays, "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[4].arg[0].value.[1].value.arg[0].value")) jours"), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0].arg[2].value.[4]")
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.all, __designTimeInteger("#5756_13", fallback: 8)), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].arg[1].value.[0]")
                    }
                    .frame(width: UIScreen.main.bounds.size.width * __designTimeFloat("#5756_14", fallback: 0.7), height: __designTimeInteger("#5756_15", fallback: 152), alignment: .topLeading)
                    .background(__designTimeSelection(Color.primaryOrange, "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].modifier[1].arg[0].value"))
                    .foregroundStyle(.white)
                    .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#5756_16", fallback: 18)), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0].modifier[3].arg[0].value")), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[0].[0]")
                } else {
                    __designTimeSelection(Button {
                        // Action to create a new challenge
                    } label: {
                        __designTimeSelection(VStack(alignment: .center, spacing: __designTimeInteger("#5756_17", fallback: 10)) {
                            __designTimeSelection(Text(__designTimeString("#5756_18", fallback: "No active challenge"))
                                .font(.title2), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0].arg[1].value.[0].arg[2].value.[0]")
                            __designTimeSelection(Text(__designTimeString("#5756_19", fallback: "Create one now"))
                                .font(.subheadline), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0].arg[1].value.[0].arg[2].value.[1]")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.all, __designTimeInteger("#5756_20", fallback: 8)), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0].arg[1].value.[0]")
                    }
                    .frame(width: UIScreen.main.bounds.size.width * __designTimeFloat("#5756_21", fallback: 0.7), height: __designTimeInteger("#5756_22", fallback: 152))
                    .background(__designTimeSelection(Color.gray.opacity(__designTimeFloat("#5756_23", fallback: 0.2)), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0].modifier[1].arg[0].value"))
                    .foregroundStyle(__designTimeSelection(Color.primary, "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0].modifier[2].arg[0].value"))
                    .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#5756_24", fallback: 18)), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0].modifier[3].arg[0].value")), "#5756.[1].[2].property.[0].[0].arg[1].value.[2].arg[0].value.[1].[1].[0]")
                }
            }, "#5756.[1].[2].property.[0].[0].arg[1].value.[2]")
        }
        .frame(maxHeight: .infinity, alignment: .top), "#5756.[1].[2].property.[0].[0]")
    }
}

#Preview {
    return HomeScreen()
}
