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
        VStack(spacing: __designTimeInteger("#7489_0", fallback: 16)) {
            HStack {
                CircularProgressView()
                CircularProgressView(color: Color.primaryOrange)
            }
            //.padding(.bottom, 32)
            VStack {
                Text(__designTimeString("#7489_1", fallback: "My challenges"))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, __designTimeInteger("#7489_2", fallback: 16))
                ScrollView(.horizontal, showsIndicators: __designTimeBoolean("#7489_3", fallback: false)) {
                    HStack {
                        ChallengeCard(
                            challenge: Challenge(
                                creatorUserID: __designTimeString("#7489_4", fallback: "123"),
                                participantsUserID: [Participant(userID: __designTimeString("#7489_5", fallback: "123"), progress: __designTimeInteger("#7489_6", fallback: 4500))],
                                name: __designTimeString("#7489_7", fallback: "Challenge 8000 pas"),
                                description: __designTimeString("#7489_8", fallback: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé"),
                                goal: Goal(
                                    distance: nil,
                                    steps: __designTimeInteger("#7489_9", fallback: 10000)
                                ),
                                duration: __designTimeInteger("#7489_10", fallback: 86400),
                                date: Date.now
                            )
                        )
                        ChallengeCard(
                            challenge: Challenge(
                                creatorUserID: __designTimeString("#7489_11", fallback: "123"),
                                participantsUserID: [Participant(userID: __designTimeString("#7489_12", fallback: "123"), progress: __designTimeInteger("#7489_13", fallback: 3000))],
                                name: __designTimeString("#7489_14", fallback: "Challenge 8000 pas"),
                                description: __designTimeString("#7489_15", fallback: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé"),
                                goal: Goal(
                                    distance: nil,
                                    steps: __designTimeInteger("#7489_16", fallback: 10000)
                                ),
                                duration: __designTimeInteger("#7489_17", fallback: 86400),
                                date: Date.now
                            )
                        )
                        ChallengeCard(
                            challenge: Challenge(
                                creatorUserID: __designTimeString("#7489_18", fallback: "123"),
                                participantsUserID: [Participant(userID: __designTimeString("#7489_19", fallback: "123"), progress: __designTimeInteger("#7489_20", fallback: 7500))],
                                name: __designTimeString("#7489_21", fallback: "Challenge 8000 pas"),
                                description: __designTimeString("#7489_22", fallback: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé"),
                                goal: Goal(
                                    distance: nil,
                                    steps: __designTimeInteger("#7489_23", fallback: 10000)
                                ),
                                duration: __designTimeInteger("#7489_24", fallback: 86400),
                                date: Date.now)
                        )
                        Button {

                        } label: {
                            Text(__designTimeString("#7489_25", fallback: "See more"))
                        }
                        .padding()
                        .background(Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#7489_26", fallback: 18)))
                        .padding(.horizontal, __designTimeInteger("#7489_27", fallback: 16))
                    }
                }
            }
            VStack {
                Text(LocalizedStringKey(__designTimeString("#7489_28", fallback: "current_challenge")))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, __designTimeInteger("#7489_29", fallback: 16))
                Button {

                } label: {
                    VStack(alignment: .leading, spacing: __designTimeInteger("#7489_30", fallback: 10)) {
                        Text(__designTimeString("#7489_31", fallback: "Challenge 8000 pas"))
                            .font(.title2)
                        ProgressView(value: __designTimeFloat("#7489_32", fallback: 4594.0), total: __designTimeFloat("#7489_33", fallback: 8000.0))
                            .progressViewStyle(LinearProgressStyle())
                        Text(__designTimeString("#7489_34", fallback: "Se termine dans 5 jours"))
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.all, __designTimeInteger("#7489_35", fallback: 8))
                }
                .frame(width: UIScreen.main.bounds.size.width * __designTimeFloat("#7489_36", fallback: 0.7), height: __designTimeInteger("#7489_37", fallback: 152), alignment: .topLeading)
                .background(Color.primaryOrange)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#7489_38", fallback: 18)))
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    HomeScreen()
}
