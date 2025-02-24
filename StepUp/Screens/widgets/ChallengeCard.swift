//
//  ChallengeCard.swift
//  StepUp
//
//  Created by Hugo Blas on 24/02/2025.
//

import SwiftUI

struct ChallengeCard: View {
    var title: String
    
    var body : some View {
        Button {
            print("\(title) was tapped")
        } label: {
            VStack {
                Text(title)
            }
        }
        .padding()
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .frame(width: 96)
        .padding(.horizontal, 4)
    }
}
