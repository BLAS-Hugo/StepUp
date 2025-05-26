//
//  ChallengeListScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 25/04/2025.
//

import SwiftUI

struct ChallengeListScreen: View {
    @EnvironmentObject var authenticationService: AuthenticationViewModel
    let challenges: [Challenge]

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(0..<challenges.count, id: \.self) { index in
                    NavigationLink {
                        ChallengeDetailScreen(challenge: challenges[index])
                            .navigationTitle(Text(challenges[index].name))
                            .navigationBarTitleDisplayMode(.large)
                    } label: {
                        ChallengeCard(
                            challenge: challenges[index],
                            userID: authenticationService.currentUser?.id ?? "",
                            style: .wide
                        )
                    }
                }
            }
        }
    }
}
