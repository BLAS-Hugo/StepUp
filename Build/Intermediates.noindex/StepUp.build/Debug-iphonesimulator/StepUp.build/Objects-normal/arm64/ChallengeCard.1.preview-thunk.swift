import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Volumes/SSD Mac/Dev/Open Classroom/projet libre/StepUp/StepUp/Screens/widgets/ChallengeCard.swift", line: 1)
//
//  ChallengeCard.swift
//  StepUp
//
//  Created by Hugo Blas on 24/02/2025.
//

import SwiftUI

struct ChallengeCard: View {
    var challenge: Challenge

    var body : some View {
        Button {
            print("\(challenge.name) was tapped")
        } label: {
            VStack {
                Text(challenge.name)
                    .font(.title2)
                    .foregroundStyle(.black)
                ProgressView(value: Double(challenge.getParticipantProgress(userID: __designTimeString("#6074_0", fallback: "123"))), total: Double(challenge.goal.getGoal()))
                    .progressViewStyle(LinearProgressStyle())
                Text(challenge.goal.getGoalForDisplay())
                    .foregroundStyle(.black)
            }
            .frame(maxHeight: __designTimeInteger("#6074_1", fallback: 256), alignment: .top)
        }
        .padding()
        .frame(width: __designTimeInteger("#6074_2", fallback: 128), height: __designTimeInteger("#6074_3", fallback: 256))
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#6074_4", fallback: 18)))
        .padding(.leading, __designTimeInteger("#6074_5", fallback: 16))
    }
}

#Preview {
    HomeScreen()
}
