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
    @State private var progress = 0.1

    var numberOfStepsDone: Int {
        let doubleValue = 10000 * progress
        return Int(doubleValue.rounded())
    }

    var body: some View {
        VStack {
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(GaugeProgressStyle(strokeColor: color))
                .frame(width: 150, height: 150)
                .contentShape(Rectangle())
                .padding()
                .onTapGesture {
                    if progress < 1.0 {
                        withAnimation {
                            progress += 0.1
                        }
                    }
                }
            Text("\(numberOfStepsDone) Steps")
        }
    }
}
