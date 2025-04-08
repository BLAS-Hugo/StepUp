//
//  Challenge.swift
//  StepUp
//
//  Created by Hugo Blas on 27/02/2025.
//

import Foundation

struct Challenge: Identifiable {
    let creatorUserID: String
    let participants: [Participant]
    let name: String
    let description: String
    let goal: Goal
    let duration: Int
    let date: Date
    let id: String

    func getParticipantProgress(userID: String) -> Int {
        return participants.first(where: { $0.userID == userID })!.progress
    }
}

extension Challenge: Codable {

}
