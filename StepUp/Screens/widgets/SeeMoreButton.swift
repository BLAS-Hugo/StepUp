//
//  SeeMoreButton.swift
//  StepUp
//
//  Created by Hugo Blas on 12/05/2025.
//

import SwiftUI

struct SeeMoreButton: View {
    let title: LocalizedStringKey
    let challenges: [Challenge]
    @EnvironmentObject var authenticationService: AuthenticationViewModel

    var body: some View {
        NavigationLink(LocalizedStringKey("see_more")) {
            ChallengeListScreen(challenges: challenges)
                .environmentObject(authenticationService)
                .navigationTitle(Text(title))
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
