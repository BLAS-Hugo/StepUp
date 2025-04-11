//
//  ObjectivesViewModel.swift
//  StepUp
//
//  Created by Hugo Blas on 11/04/2025.
//

import Foundation

class ObjectivesViewModel: ObservableObject {
    @Published var numberOfSteps = 0
    @Published var distance = 0

    let defaults = UserDefaults.standard

    init(numberOfSteps: Int = 0, distance: Int = 0) {
        fetchData()
    }

    func fetchData() {
        numberOfSteps = defaults.integer(forKey: "steps")
        distance = defaults.integer(forKey: "distance")
    }

    func saveData(for key: String, data: Int) {
        defaults.setValue(data, forKey: key)
    }

    func incrementData(for key: String) {
        if key == "steps" {
            if numberOfSteps < 50000 {
                numberOfSteps += 500
            }
        } else if key == "distance" {
            if distance < 50000 {
                distance += 500
            }
        }
    }

    func decrementData(for key: String) {
        if key == "steps" {
            if numberOfSteps > 0 {
                numberOfSteps -= 500
            }
        } else if key == "distance" {
            if distance > 0 {
                distance -= 500
            }
        }
    }
}
