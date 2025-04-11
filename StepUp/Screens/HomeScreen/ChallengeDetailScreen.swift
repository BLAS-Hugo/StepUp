//
//  ChallengeDetailScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 11/04/2025.
//

import SwiftUI

struct ChallengeDetailScreen: View {
    let challenge: Challenge
    
    var body: some View {
        VStack {
            Text(challenge.description)
        }
    }
}

#Preview {
    ChallengeDetailScreen(challenge: Challenge(
        creatorUserID: "123",
        participants: [
            Participant(userID: "123", progress: 3400),
            Participant(userID: "1234", progress: 2300),
            Participant(userID: "1235", progress: 7200),
            Participant(userID: "1236", progress: 1234)
        ],
        name: "5000 pas par jour",
        description: "Pour garder la santé il faut faire au moins 5000 pas par jour",
        goal: Goal(distance: nil, steps: 5000),
        duration: 86400,
        date: Date(),
        id: "234"
            )
    )
    .navigationTitle(Text("5000 pas par jour"))
    .navigationBarTitleDisplayMode(.large)
}
