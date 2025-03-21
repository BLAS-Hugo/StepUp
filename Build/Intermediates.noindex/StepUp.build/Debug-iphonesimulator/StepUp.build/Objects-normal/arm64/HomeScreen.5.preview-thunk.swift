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
    var body: some View {
        __designTimeSelection(VStack(spacing: __designTimeInteger("#2960_0", fallback: 24)) {
            __designTimeSelection(HStack {
                __designTimeSelection(CircularProgressView(), "#2960.[1].[0].property.[0].[0].arg[1].value.[0].arg[0].value.[0]")
                __designTimeSelection(CircularProgressView(color: __designTimeSelection(Color.primaryOrange, "#2960.[1].[0].property.[0].[0].arg[1].value.[0].arg[0].value.[1].arg[0].value")), "#2960.[1].[0].property.[0].[0].arg[1].value.[0].arg[0].value.[1]")
            }, "#2960.[1].[0].property.[0].[0].arg[1].value.[0]")
            //.padding(.bottom, 32)
            __designTimeSelection(Text(__designTimeString("#2960_1", fallback: "My challenges"))
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, __designTimeInteger("#2960_2", fallback: 16)), "#2960.[1].[0].property.[0].[0].arg[1].value.[1]")
            __designTimeSelection(ScrollView(.horizontal, showsIndicators: __designTimeBoolean("#2960_3", fallback: false)) {
                __designTimeSelection(HStack {
                    __designTimeSelection(ChallengeCard(
                        challenge: __designTimeSelection(Challenge(
                            creatorUserID: __designTimeString("#2960_4", fallback: "123"),
                            participantsUserID: [Participant(userID: __designTimeString("#2960_5", fallback: "123"), progress: __designTimeInteger("#2960_6", fallback: 4500))],
                            name: __designTimeString("#2960_7", fallback: "Challenge 8000 pas"),
                            description: __designTimeString("#2960_8", fallback: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé"),
                            goal: __designTimeSelection(Goal(
                                distance: nil,
                                steps: __designTimeInteger("#2960_9", fallback: 10000)
                            ), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[0].arg[0].value.arg[4].value"),
                            duration: __designTimeInteger("#2960_10", fallback: 86400),
                            date: __designTimeSelection(Date.now, "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[0].arg[0].value.arg[6].value")
                        ), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[0].arg[0].value")
                    ), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[0]")
                    __designTimeSelection(ChallengeCard(
                        challenge: __designTimeSelection(Challenge(
                            creatorUserID: __designTimeString("#2960_11", fallback: "123"),
                            participantsUserID: [Participant(userID: __designTimeString("#2960_12", fallback: "123"), progress: __designTimeInteger("#2960_13", fallback: 3000))],
                            name: __designTimeString("#2960_14", fallback: "Challenge 8000 pas"),
                            description: __designTimeString("#2960_15", fallback: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé"),
                            goal: __designTimeSelection(Goal(
                                distance: nil,
                                steps: __designTimeInteger("#2960_16", fallback: 10000)
                            ), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[1].arg[0].value.arg[4].value"),
                            duration: __designTimeInteger("#2960_17", fallback: 86400),
                            date: __designTimeSelection(Date.now, "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[1].arg[0].value.arg[6].value")
                        ), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[1].arg[0].value")
                    ), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[1]")
                    __designTimeSelection(ChallengeCard(
                        challenge: __designTimeSelection(Challenge(
                            creatorUserID: __designTimeString("#2960_18", fallback: "123"),
                            participantsUserID: [Participant(userID: __designTimeString("#2960_19", fallback: "123"), progress: __designTimeInteger("#2960_20", fallback: 7500))],
                            name: __designTimeString("#2960_21", fallback: "Challenge 8000 pas"),
                            description: __designTimeString("#2960_22", fallback: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé"),
                            goal: __designTimeSelection(Goal(
                                distance: nil,
                                steps: __designTimeInteger("#2960_23", fallback: 10000)
                            ), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[2].arg[0].value.arg[4].value"),
                            duration: __designTimeInteger("#2960_24", fallback: 86400),
                            date: __designTimeSelection(Date.now, "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[2].arg[0].value.arg[6].value")), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[2].arg[0].value")
                    ), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[2]")
                    __designTimeSelection(Button {

                    } label: {
                        __designTimeSelection(Text(__designTimeString("#2960_25", fallback: "See more")), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[3].arg[1].value.[0]")
                    }
                    .padding()
                    .frame(width: __designTimeInteger("#2960_26", fallback: 128), height: __designTimeInteger("#2960_27", fallback: 256))
                    .background(__designTimeSelection(Color(.systemFill), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[3].modifier[2].arg[0].value"))
                    .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#2960_28", fallback: 18)), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[3].modifier[3].arg[0].value"))
                    .padding(.horizontal, __designTimeInteger("#2960_29", fallback: 16)), "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0].arg[0].value.[3]")
                }, "#2960.[1].[0].property.[0].[0].arg[1].value.[2].arg[2].value.[0]")
            }, "#2960.[1].[0].property.[0].[0].arg[1].value.[2]")
        }
        .frame(maxHeight: .infinity, alignment: .top), "#2960.[1].[0].property.[0].[0]")
        __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#2960_30", fallback: "current_challenge")), "#2960.[1].[0].property.[0].[1].arg[0].value"))
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, __designTimeInteger("#2960_31", fallback: 16)), "#2960.[1].[0].property.[0].[1]")
        __designTimeSelection(Button {

        } label: {
            __designTimeSelection(VStack(alignment: .leading, spacing: __designTimeInteger("#2960_32", fallback: 10)) {
                __designTimeSelection(Text(__designTimeString("#2960_33", fallback: "Challenge 8000 pas"))
                    .font(.title2), "#2960.[1].[0].property.[0].[2].arg[1].value.[0].arg[2].value.[0]")
                __designTimeSelection(ProgressView(value: __designTimeFloat("#2960_34", fallback: 4594.0), total: __designTimeFloat("#2960_35", fallback: 8000.0))
                    .progressViewStyle(__designTimeSelection(LinearProgressStyle(), "#2960.[1].[0].property.[0].[2].arg[1].value.[0].arg[2].value.[1].modifier[0].arg[0].value")), "#2960.[1].[0].property.[0].[2].arg[1].value.[0].arg[2].value.[1]")
                __designTimeSelection(Text(__designTimeString("#2960_36", fallback: "Se termine dans 5 jours")), "#2960.[1].[0].property.[0].[2].arg[1].value.[0].arg[2].value.[2]")
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.all, __designTimeInteger("#2960_37", fallback: 8)), "#2960.[1].[0].property.[0].[2].arg[1].value.[0]")
        }
        .frame(width: UIScreen.main.bounds.size.width * __designTimeFloat("#2960_38", fallback: 0.7), height: __designTimeInteger("#2960_39", fallback: 152), alignment: .topLeading)
        .background(__designTimeSelection(Color.primaryOrange, "#2960.[1].[0].property.[0].[2].modifier[1].arg[0].value"))
        .foregroundStyle(.white)
        .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#2960_40", fallback: 18)), "#2960.[1].[0].property.[0].[2].modifier[3].arg[0].value")), "#2960.[1].[0].property.[0].[2]")
    }
}

#Preview {
    HomeScreen()
}
