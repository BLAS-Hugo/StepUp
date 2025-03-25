import func SwiftUI.__designTimeSelection

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
        __designTimeSelection(Button {
            __designTimeSelection(print("\(__designTimeSelection(challenge.name, "#7803.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].value.arg[0].value")) was tapped"), "#7803.[1].[1].property.[0].[0].arg[0].value.[0]")
        } label: {
            __designTimeSelection(VStack(spacing: __designTimeInteger("#7803_0", fallback: 1)) {
                __designTimeSelection(Text(__designTimeSelection(challenge.name, "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[0].arg[0].value"))
                    .font(.title2)
                    .foregroundStyle(.black), "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[0]")
                __designTimeSelection(ProgressView(value: __designTimeSelection(Double(__designTimeSelection(challenge.getParticipantProgress(userID: __designTimeString("#7803_1", fallback: "123")), "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[1].arg[0].value.arg[0].value")), "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[1].arg[0].value"), total: __designTimeSelection(Double(__designTimeSelection(challenge.goal.getGoal(), "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[1].arg[1].value.arg[0].value")), "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[1].arg[1].value"))
                    .progressViewStyle(__designTimeSelection(LinearProgressStyle(), "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[1].modifier[0].arg[0].value")), "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[1]")
                __designTimeSelection(Text(__designTimeSelection(challenge.goal.getGoalForDisplay(), "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[2].arg[0].value"))
                    .foregroundStyle(.black), "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[2]")
                __designTimeSelection(Text(
                    __designTimeSelection(challenge.date, "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[3].arg[0].value"),
                    format: __designTimeSelection(.dateTime.day().month().year(), "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[3].arg[1].value"))
                    .foregroundStyle(.black), "#7803.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[3]")
            }
            .padding()
            .frame(alignment: .top), "#7803.[1].[1].property.[0].[0].arg[1].value.[0]")
        }
        .background(__designTimeSelection(Color(.systemFill), "#7803.[1].[1].property.[0].[0].modifier[0].arg[0].value"))
        .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#7803_2", fallback: 18)), "#7803.[1].[1].property.[0].[0].modifier[1].arg[0].value"))
        .padding(.leading, __designTimeInteger("#7803_3", fallback: 16))
        .frame(maxWidth: __designTimeInteger("#7803_4", fallback: 156), maxHeight: __designTimeInteger("#7803_5", fallback: 200)), "#7803.[1].[1].property.[0].[0]")
    }
}

#Preview {
    HomeScreen()
}
