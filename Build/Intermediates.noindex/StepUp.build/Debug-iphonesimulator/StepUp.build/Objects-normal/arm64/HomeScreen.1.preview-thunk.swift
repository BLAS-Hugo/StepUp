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
        VStack(spacing: __designTimeInteger("#2960_0", fallback: 24)) {
            HStack {
                CircularProgressView()
                CircularProgressView(color: Color.primaryOrange)
            }
            //.padding(.bottom, 32)
            Text(__designTimeString("#2960_1", fallback: "My challenges"))
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, __designTimeInteger("#2960_2", fallback: 16))
            ScrollView(.horizontal, showsIndicators: __designTimeBoolean("#2960_3", fallback: false)) {
                HStack {
                    ChallengeCard(
                        challenge: Challenge(
                            creatorUserID: __designTimeString("#2960_4", fallback: "123"),
                            participantsUserID: [Participant(userID: __designTimeString("#2960_5", fallback: "123"), progress: __designTimeInteger("#2960_6", fallback: 4500))],
                            name: __designTimeString("#2960_7", fallback: "Challenge 8000 pas"),
                            description: __designTimeString("#2960_8", fallback: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé"),
                            goal: Goal(
                                distance: nil,
                                steps: __designTimeInteger("#2960_9", fallback: 10000)
                            ),
                            duration: __designTimeInteger("#2960_10", fallback: 86400),
                            date: Date.now
                        )
                    )
                    ChallengeCard(
                        challenge: Challenge(
                            creatorUserID: __designTimeString("#2960_11", fallback: "123"),
                            participantsUserID: [Participant(userID: __designTimeString("#2960_12", fallback: "123"), progress: __designTimeInteger("#2960_13", fallback: 3000))],
                            name: __designTimeString("#2960_14", fallback: "Challenge 8000 pas"),
                            description: __designTimeString("#2960_15", fallback: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé"),
                            goal: Goal(
                                distance: nil,
                                steps: __designTimeInteger("#2960_16", fallback: 10000)
                            ),
                            duration: __designTimeInteger("#2960_17", fallback: 86400),
                            date: Date.now
                        )
                    )
                    ChallengeCard(
                        challenge: Challenge(
                            creatorUserID: __designTimeString("#2960_18", fallback: "123"),
                            participantsUserID: [Participant(userID: __designTimeString("#2960_19", fallback: "123"), progress: __designTimeInteger("#2960_20", fallback: 7500))],
                            name: __designTimeString("#2960_21", fallback: "Challenge 8000 pas"),
                            description: __designTimeString("#2960_22", fallback: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé"),
                            goal: Goal(
                                distance: nil,
                                steps: __designTimeInteger("#2960_23", fallback: 10000)
                            ),
                            duration: __designTimeInteger("#2960_24", fallback: 86400),
                            date: Date.now)
                    )
                    Button {

                    } label: {
                        Text(__designTimeString("#2960_25", fallback: "See more"))
                    }
                    .padding()
                    .frame(width: __designTimeInteger("#2960_26", fallback: 128), height: __designTimeInteger("#2960_27", fallback: 256))
                    .background(Color(.systemFill))
                    .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#2960_28", fallback: 18)))
                    .padding(.horizontal, __designTimeInteger("#2960_29", fallback: 16))
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        Text(LocalizedStringKey(__designTimeString("#2960_30", fallback: "current_challenge")))
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, __designTimeInteger("#2960_31", fallback: 16))
        Button {

        } label: {
            VStack(alignment: .leading, spacing: __designTimeInteger("#2960_32", fallback: 10)) {
                Text(__designTimeString("#2960_33", fallback: "Challenge 8000 pas"))
                    .font(.title2)
                ProgressView(value: __designTimeFloat("#2960_34", fallback: 4594.0), total: __designTimeFloat("#2960_35", fallback: 8000.0))
                    .progressViewStyle(LinearProgressStyle())
                Text(__designTimeString("#2960_36", fallback: "Se termine dans 5 jours"))
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.all, __designTimeInteger("#2960_37", fallback: 8))
        }
        .frame(width: UIScreen.main.bounds.size.width * __designTimeFloat("#2960_38", fallback: 0.7), height: __designTimeInteger("#2960_39", fallback: 152), alignment: .topLeading)
        .background(Color.primaryOrange)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#2960_40", fallback: 18)))
    }
}

#Preview {
    HomeScreen()
}
