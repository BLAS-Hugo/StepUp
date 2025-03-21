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

        GeometryReader {
            geometry in
            ZStack {
                RoundedRectangle(cornerRadius: __designTimeFloat("#6932_1", fallback: 10.0))
                    .fill(.gray.opacity(__designTimeFloat("#6932_2", fallback: 0.2)))
                    .frame(width: geometry.size.width, height: strokeHeight)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: __designTimeFloat("#6932_3", fallback: 10.0))
                            .fill(strokeColor)
                            .frame(width: geometry.size.width * fractionCompleted, height: strokeHeight)
                    }
            }
        }
        .frame(maxHeight: strokeHeight + __designTimeInteger("#6932_4", fallback: 4))
    }
}

#Preview {
    HomeScreen()
}
