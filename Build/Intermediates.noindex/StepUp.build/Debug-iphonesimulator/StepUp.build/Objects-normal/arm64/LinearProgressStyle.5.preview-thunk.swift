import func SwiftUI.__designTimeSelection

import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Volumes/SSD Mac/Dev/Open Classroom/projet libre/StepUp/StepUp/Screens/widgets/LinearProgressStyle.swift", line: 1)
//
//  LinearProgressStyle.swift
//  StepUp
//
//  Created by Hugo Blas on 28/02/2025.
//

import SwiftUI

struct LinearProgressStyle: ProgressViewStyle {
    var strokeColor = Color.blue
    var strokeHeight = 12.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? __designTimeInteger("#6932_0", fallback: 0)

        __designTimeSelection(GeometryReader {
            geometry in
            __designTimeSelection(ZStack {
                __designTimeSelection(RoundedRectangle(cornerRadius: __designTimeFloat("#6932_1", fallback: 10.0))
                    .fill(__designTimeSelection(.gray.opacity(__designTimeFloat("#6932_2", fallback: 0.2)), "#6932.[1].[2].[1].arg[0].value.[0].arg[0].value.[0].modifier[0].arg[0].value"))
                    .frame(width: __designTimeSelection(geometry.size.width, "#6932.[1].[2].[1].arg[0].value.[0].arg[0].value.[0].modifier[1].arg[0].value"), height: __designTimeSelection(strokeHeight, "#6932.[1].[2].[1].arg[0].value.[0].arg[0].value.[0].modifier[1].arg[1].value"))
                    .overlay(alignment: .leading) {
                        __designTimeSelection(RoundedRectangle(cornerRadius: __designTimeFloat("#6932_3", fallback: 10.0))
                            .fill(__designTimeSelection(strokeColor, "#6932.[1].[2].[1].arg[0].value.[0].arg[0].value.[0].modifier[2].arg[1].value.[0].modifier[0].arg[0].value"))
                            .frame(width: geometry.size.width * fractionCompleted, height: __designTimeSelection(strokeHeight, "#6932.[1].[2].[1].arg[0].value.[0].arg[0].value.[0].modifier[2].arg[1].value.[0].modifier[1].arg[1].value")), "#6932.[1].[2].[1].arg[0].value.[0].arg[0].value.[0].modifier[2].arg[1].value.[0]")
                    }, "#6932.[1].[2].[1].arg[0].value.[0].arg[0].value.[0]")
            }, "#6932.[1].[2].[1].arg[0].value.[0]")
        }
        .frame(maxHeight: strokeHeight + __designTimeInteger("#6932_4", fallback: 4)), "#6932.[1].[2].[1]")
    }
}

#Preview {
    HomeScreen()
}
