//
//  CircularProgressView.swift
//  StepUp
//
//  Created by Hugo Blas on 26/02/2025.
//

import SwiftUI
import Foundation

struct CircularProgressView: View {
    var color = Color.secondaryBlue
    var progress: Int
    var type = ProgressViewType.steps

    private let debugGoal: Double = 8000

    var body: some View {
        VStack {
            ProgressView(value: Double(progress), total: debugGoal)
                .progressViewStyle(GaugeProgressStyle(strokeColor: color))
                .frame(width: 128, height: 128)
                .contentShape(Rectangle())
                .padding()
            if type == .steps {
                Text("\(progress) Steps")
            } else {
                Text("\(progress) KM")
            }
        }
    }
}

enum ProgressViewType {
    case steps, distance
}
