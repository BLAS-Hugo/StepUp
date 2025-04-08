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
            VStack(spacing: __designTimeInteger("#8900_0", fallback: 16)) {
                Text(challenge.name)
                    .font(.title2)
                    .foregroundStyle(.black)
                ProgressView(value: Double(challenge.getParticipantProgress(userID: __designTimeString("#8900_1", fallback: "123"))), total: Double(challenge.goal.getGoal()))
                    .progressViewStyle(LinearProgressStyle())
                Text(challenge.goal.getGoalForDisplay())
                    .foregroundStyle(.black)
                Text(
                    challenge.date,
                    format: .dateTime.day().month().year())
                    .foregroundStyle(.black)
            }
            .padding()
            .frame(alignment: .top)
        }
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#8900_2", fallback: 18)))
        .padding(.leading, __designTimeInteger("#8900_3", fallback: 16))
        .frame(maxWidth: __designTimeInteger("#8900_4", fallback: 156), maxHeight: __designTimeInteger("#8900_5", fallback: 200))
    }
}

#Preview {
    HomeScreen()
}
