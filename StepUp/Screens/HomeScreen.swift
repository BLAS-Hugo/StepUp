//
//  HomeScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        HStack {
            Text("Roue G")
            Text("Roue D")
        }
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ChallengeCard(title: "challenge 1")
                ChallengeCard(title: "challenge 2")
                ChallengeCard(title: "challenge 3")
                ChallengeCard(title: "See more")
            }
        }
    }
}

#Preview {
    HomeScreen()
}
