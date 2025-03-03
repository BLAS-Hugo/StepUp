//
//  Goal.swift
//  StepUp
//
//  Created by Hugo Blas on 27/02/2025.
//

struct Goal {
    let distance: Int?
    let steps: Int?

    func getGoal() -> Int {
        if let distance = distance {
            return distance
        } else {
            return steps!
        }
    }

    func getGoalForDisplay() -> String {
        if let distance = distance {
            return "\(distance) KM"
        } else {
            return "\(steps!) steps"
        }
    }
}
