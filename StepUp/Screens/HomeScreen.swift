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
            CircularProgressView()
            CircularProgressView(color: .orange)
        }
        .padding(.bottom, 32)
        Text("My challenges")
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 32)
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
