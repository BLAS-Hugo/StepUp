//
//  HomeScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        VStack {
            HStack {
                CircularProgressView()
                CircularProgressView(color: .orange)
            }
            .padding(.bottom, 32)
            Text("My challenges")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ChallengeCard(
                        challenge: Challenge(
                            creatorUserID: "123",
                            participantsUserID: [Participant(userID: "123", progress: 4500)],
                            name: "Challenge 8000 pas",
                            description: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé",
                            goal: Goal(
                                distance: nil,
                                steps: 10000
                            ),
                            duration: 86400,
                            date: Date.now
                        )
                    )
                    ChallengeCard(
                        challenge: Challenge(
                            creatorUserID: "123",
                            participantsUserID: [Participant(userID: "123", progress: 3000)],
                            name: "Challenge 8000 pas",
                            description: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé",
                            goal: Goal(
                                distance: nil,
                                steps: 10000
                            ),
                            duration: 86400,
                            date: Date.now
                        )
                    )
                    ChallengeCard(
                        challenge: Challenge(
                            creatorUserID: "123",
                            participantsUserID: [Participant(userID: "123", progress: 7500)],
                            name: "Challenge 8000 pas",
                            description: "Le but est de parcourir 10000 pas en un jour afin de garantir une bonne santé",
                            goal: Goal(
                                distance: nil,
                                steps: 10000
                            ),
                            duration: 86400,
                            date: Date.now)
                    )
                    Button {

                    } label: {
                        Text("See more")
                    }
                    .padding()
                    .frame(width: 128, height: 256)
                    .background(Color(.systemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)

        Text("current challenge")
    }
}

#Preview {
    HomeScreen()
}
