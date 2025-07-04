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
            return steps ?? 0
        }
    }

    func getGoalForDisplay() -> String {
        if let distance = distance {
            return "\(distance / 1000) KM"
        } else {
            return "\(steps ?? 0) steps"
        }
    }
}

extension Goal: Codable {

}
