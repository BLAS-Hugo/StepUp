//
//  ObjectivesScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 10/04/2025.
//

import SwiftUI

struct ObjectivesScreen: View {
    @EnvironmentObject var objectivesViewModel: ObjectivesViewModel

//    init() {
//        objectivesViewModel.fetchData()
//    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Nombre de pas")
                        .font(.title3)
                    HStack {
                        Button {
                            objectivesViewModel.decrementData(for: "steps")
                            objectivesViewModel.saveData(for: "steps", data: objectivesViewModel.numberOfSteps)
                        } label: {
                            ZStack {
                                Image(systemName: "minus")
                                    .padding(.vertical, 16)
                            }
                            .frame(width: 16, height: 16)
                            .background(Color.appLightGray)
                            .clipShape(Circle())
                        }
                        Spacer()
                        Text("\(objectivesViewModel.numberOfSteps)")
                        Spacer()
                        Button {
                            objectivesViewModel.incrementData(for: "steps")
                            objectivesViewModel.saveData(for: "steps", data: objectivesViewModel.numberOfSteps)
                        } label: {
                            ZStack {
                                Image(systemName: "plus")
                                    .padding(.vertical, 16)
                            }
                            .frame(width: 16, height: 16)
                            .background(Color.appLightGray)
                            .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 64)
                }
                .padding(.horizontal, 32)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Nombre de kilomètres")
                        .font(.title3)
                    HStack {
                        Button {
                            objectivesViewModel.decrementData(for: "distance")
                            objectivesViewModel.saveData(for: "distance", data: objectivesViewModel.distance)
                        } label: {
                            ZStack {
                                Image(systemName: "minus")
                                    .padding(.vertical, 16)
                            }
                            .frame(width: 16, height: 16)
                            .background(Color.appLightGray)
                            .clipShape(Circle())
                        }
                        Spacer()
                        Text("\(Double(objectivesViewModel.distance) / 1000, specifier: "%.1f")")
                        Spacer()
                        Button {
                            objectivesViewModel.incrementData(for: "distance")
                            objectivesViewModel.saveData(for: "distance", data: objectivesViewModel.distance)
                        } label: {
                            ZStack {
                                Image(systemName: "plus")
                                    .padding(.vertical, 16)
                            }
                            .frame(width: 16, height: 16)
                            .background(Color.appLightGray)
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
