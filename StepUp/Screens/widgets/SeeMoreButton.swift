//
//  SeeMoreButton.swift
//  StepUp
//
//  Created by Hugo Blas on 12/05/2025.
//

import SwiftUI

struct SeeMoreButton: View {
    let title: String
    let challenges: [Challenge]
    @EnvironmentObject var authenticationService: AuthenticationService

    var body: some View {
        NavigationLink("Voir plus") {
            ChallengeListScreen(challenges: challenges)
                .environmentObject(authenticationService)
                .navigationTitle(Text(title))
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
