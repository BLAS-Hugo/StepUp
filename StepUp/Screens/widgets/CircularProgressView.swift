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
    let progress: Int
    var type = ProgressViewType.steps
    let goal: Int

    var body: some View {
        VStack {
            ProgressView(value: Double(min(progress, goal)), total: Double(goal))
                .progressViewStyle(GaugeProgressStyle(strokeColor: color))
                .frame(width: 128, height: 128)
                .contentShape(Rectangle())
                .padding()
            if type == .steps {
                Text("\(progress) Steps")
            } else {
                Text("\(Double(progress) / 1000, specifier: "%.1f") KM")
            }
        }
    }
}

enum ProgressViewType {
    case steps, distance
}
