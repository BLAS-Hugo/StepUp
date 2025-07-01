//
//  ObjectivesScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 10/04/2025.
//

import SwiftUI

struct ObjectivesScreen: View {
    @EnvironmentObject var goalViewModel: GoalViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(LocalizedStringKey("number_of_steps"))
                        .font(.title3)
                    HStack {
                        Button {
                            goalViewModel.decrementData(for: "steps")
                            goalViewModel.saveData(for: "steps", data: goalViewModel.numberOfSteps)
                        } label: {
                            ZStack {
                                Image(systemName: "minus")
                                    .accessibilityLabel(LocalizedStringKey("decrement_goal"))
                                    .padding(.vertical, 16)
                            }
                            .frame(width: 32, height: 32)
                            .background(Color(.systemFill))
                            .clipShape(Circle())
                        }
                        Spacer()
                        Text("\(goalViewModel.numberOfSteps)")
                        Spacer()
                        Button {
                            goalViewModel.incrementData(for: "steps")
                            goalViewModel.saveData(for: "steps", data: goalViewModel.numberOfSteps)
                        } label: {
                            ZStack {
                                Image(systemName: "plus")
                                    .accessibilityLabel(LocalizedStringKey("increment_goal"))
                                    .padding(.vertical, 16)
                            }
                            .frame(width: 32, height: 32)
                            .background(Color(.systemFill))
                            .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 64)
                }
                .padding(.horizontal, 32)
                VStack(alignment: .leading, spacing: 16) {
                    Text(LocalizedStringKey("number_of_km"))
                        .font(.title3)
                    HStack {
                        Button {
                            goalViewModel.decrementData(for: "distance")
                            goalViewModel.saveData(for: "distance", data: goalViewModel.distance)
                        } label: {
                            ZStack {
                                Image(systemName: "minus")
                                    .accessibilityLabel(LocalizedStringKey("decrement_goal"))
                                    .padding(.vertical, 16)
                            }
                            .frame(width: 32, height: 32)
                            .background(Color(.systemFill))
                            .clipShape(Circle())
                        }
                        Spacer()
                        Text("\(Double(goalViewModel.distance) / 1000, specifier: "%.1f")")
                        Spacer()
                        Button {
                            goalViewModel.incrementData(for: "distance")
                            goalViewModel.saveData(for: "distance", data: goalViewModel.distance)
                        } label: {
                            ZStack {
                                Image(systemName: "plus")
                                    .accessibilityLabel(LocalizedStringKey("increment_goal"))
                                    .padding(.vertical, 16)
                            }
                            .frame(width: 32, height: 32)
                            .background(Color(.systemFill))
                            .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 64)
                }
                .padding(.horizontal, 32)
                Spacer()
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .padding(.top, 32)
        }
    }
}
