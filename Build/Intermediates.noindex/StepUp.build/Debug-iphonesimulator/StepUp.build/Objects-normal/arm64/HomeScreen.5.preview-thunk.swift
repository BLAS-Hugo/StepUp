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

    var body: some View {
        __designTimeSelection(VStack(spacing: __designTimeInteger("#7489_0", fallback: 16)) {
            __designTimeSelection(HStack {
                __designTimeSelection(CircularProgressView(), "#7489.[1].[1].property.[0].[0].arg[1].value.[0].arg[0].value.[0]")
                __designTimeSelection(CircularProgressView(color: __designTimeSelection(Color.primaryOrange, "#7489.[1].[1].property.[0].[0].arg[1].value.[0].arg[0].value.[1].arg[0].value")), "#7489.[1].[1].property.[0].[0].arg[1].value.[0].arg[0].value.[1]")
            }, "#7489.[1].[1].property.[0].[0].arg[1].value.[0]")
            //.padding(.bottom, 32)
            __designTimeSelection(VStack {
                __designTimeSelection(Text(__designTimeString("#7489_1", fallback: "My challenges"))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, __designTimeInteger("#7489_2", fallback: 16)), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[0]")
                __designTimeSelection(ScrollView(.horizontal, showsIndicators: __designTimeBoolean("#7489_3", fallback: false)) {
                    __designTimeSelection(HStack {
                        __designTimeSelection(ChallengeCard(
                            challenge: __designTimeSelection(Challenge(
                                creatorUserID: __designTimeString("#7489_4", fallback: "123"),
                                participantsUserID: [Participant(userID: __designTimeString("#7489_5", fallback: "123"), progress: __designTimeInteger("#7489_6", fallback: 4500))],
                                name: __designTimeString("#7489_7", fallback: "Challenge 8000 pas"),
                                description: __designTimeString("#7489_8", fallback: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé"),
                                goal: __designTimeSelection(Goal(
                                    distance: nil,
                                    steps: __designTimeInteger("#7489_9", fallback: 10000)
                                ), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[0].arg[0].value.arg[4].value"),
                                duration: __designTimeInteger("#7489_10", fallback: 86400),
                                date: __designTimeSelection(Date.now, "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[0].arg[0].value.arg[6].value")
                            ), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[0].arg[0].value")
                        ), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[0]")
                        __designTimeSelection(ChallengeCard(
                            challenge: __designTimeSelection(Challenge(
                                creatorUserID: __designTimeString("#7489_11", fallback: "123"),
                                participantsUserID: [Participant(userID: __designTimeString("#7489_12", fallback: "123"), progress: __designTimeInteger("#7489_13", fallback: 3000))],
                                name: __designTimeString("#7489_14", fallback: "Challenge 8000 pas"),
                                description: __designTimeString("#7489_15", fallback: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé"),
                                goal: __designTimeSelection(Goal(
                                    distance: nil,
                                    steps: __designTimeInteger("#7489_16", fallback: 10000)
                                ), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[1].arg[0].value.arg[4].value"),
                                duration: __designTimeInteger("#7489_17", fallback: 86400),
                                date: __designTimeSelection(Date.now, "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[1].arg[0].value.arg[6].value")
                            ), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[1].arg[0].value")
                        ), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[1]")
                        __designTimeSelection(ChallengeCard(
                            challenge: __designTimeSelection(Challenge(
                                creatorUserID: __designTimeString("#7489_18", fallback: "123"),
                                participantsUserID: [Participant(userID: __designTimeString("#7489_19", fallback: "123"), progress: __designTimeInteger("#7489_20", fallback: 7500))],
                                name: __designTimeString("#7489_21", fallback: "Challenge 8000 pas"),
                                description: __designTimeString("#7489_22", fallback: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé"),
                                goal: __designTimeSelection(Goal(
                                    distance: nil,
                                    steps: __designTimeInteger("#7489_23", fallback: 10000)
                                ), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[2].arg[0].value.arg[4].value"),
                                duration: __designTimeInteger("#7489_24", fallback: 86400),
                                date: __designTimeSelection(Date.now, "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[2].arg[0].value.arg[6].value")), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[2].arg[0].value")
                        ), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[2]")
                        __designTimeSelection(Button {

                        } label: {
                            __designTimeSelection(Text(__designTimeString("#7489_25", fallback: "See more")), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[3].arg[1].value.[0]")
                        }
                        .padding()
                        .background(__designTimeSelection(Color(.systemFill), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[3].modifier[1].arg[0].value"))
                        .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#7489_26", fallback: 18)), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[3].modifier[2].arg[0].value"))
                        .padding(.horizontal, __designTimeInteger("#7489_27", fallback: 16)), "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0].arg[0].value.[3]")
                    }, "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1].arg[2].value.[0]")
                }, "#7489.[1].[1].property.[0].[0].arg[1].value.[1].arg[0].value.[1]")
            }, "#7489.[1].[1].property.[0].[0].arg[1].value.[1]")
            __designTimeSelection(VStack {
                __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#7489_28", fallback: "current_challenge")), "#7489.[1].[1].property.[0].[0].arg[1].value.[2].arg[0].value.[0].arg[0].value"))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, __designTimeInteger("#7489_29", fallback: 16)), "#7489.[1].[1].property.[0].[0].arg[1].value.[2].arg[0].value.[0]")
                __designTimeSelection(Button {

                } label: {
                    __designTimeSelection(VStack(alignment: .leading, spacing: __designTimeInteger("#7489_30", fallback: 10)) {
                        __designTimeSelection(Text(__designTimeString("#7489_31", fallback: "Challenge 8000 pas"))
                            .font(.title2), "#7489.[1].[1].property.[0].[0].arg[1].value.[2].arg[0].value.[1].arg[1].value.[0].arg[2].value.[0]")
                        __designTimeSelection(ProgressView(value: __designTimeFloat("#7489_32", fallback: 4594.0), total: __designTimeFloat("#7489_33", fallback: 8000.0))
                            .progressViewStyle(__designTimeSelection(LinearProgressStyle(), "#7489.[1].[1].property.[0].[0].arg[1].value.[2].arg[0].value.[1].arg[1].value.[0].arg[2].value.[1].modifier[0].arg[0].value")), "#7489.[1].[1].property.[0].[0].arg[1].value.[2].arg[0].value.[1].arg[1].value.[0].arg[2].value.[1]")
                        __designTimeSelection(Text(__designTimeString("#7489_34", fallback: "Se termine dans 5 jours")), "#7489.[1].[1].property.[0].[0].arg[1].value.[2].arg[0].value.[1].arg[1].value.[0].arg[2].value.[2]")
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.all, __designTimeInteger("#7489_35", fallback: 8)), "#7489.[1].[1].property.[0].[0].arg[1].value.[2].arg[0].value.[1].arg[1].value.[0]")
                }
                .frame(width: UIScreen.main.bounds.size.width * __designTimeFloat("#7489_36", fallback: 0.7), height: __designTimeInteger("#7489_37", fallback: 152), alignment: .topLeading)
                .background(__designTimeSelection(Color.primaryOrange, "#7489.[1].[1].property.[0].[0].arg[1].value.[2].arg[0].value.[1].modifier[1].arg[0].value"))
                .foregroundStyle(.white)
                .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#7489_38", fallback: 18)), "#7489.[1].[1].property.[0].[0].arg[1].value.[2].arg[0].value.[1].modifier[3].arg[0].value")), "#7489.[1].[1].property.[0].[0].arg[1].value.[2].arg[0].value.[1]")
            }, "#7489.[1].[1].property.[0].[0].arg[1].value.[2]")
        }
        .frame(maxHeight: .infinity, alignment: .top), "#7489.[1].[1].property.[0].[0]")
    }
}

#Preview {
    HomeScreen()
}
