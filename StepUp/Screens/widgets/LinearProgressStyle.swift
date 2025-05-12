//
//  LinearProgressStyle.swift
//  StepUp
//
//  Created by Hugo Blas on 28/02/2025.
//

import SwiftUI

struct LinearProgressStyle: ProgressViewStyle {
    var strokeColor = Color.secondaryBlue
    var strokeHeight = 12.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(.gray.opacity(0.2))
                    .frame(width: geometry.size.width, height: strokeHeight)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(strokeColor)
                            .frame(width: geometry.size.width * fractionCompleted, height: strokeHeight)
                    }
            }
        }
        .frame(maxHeight: strokeHeight + 4)
    }
}

#Preview {
    HomeScreen()
}
