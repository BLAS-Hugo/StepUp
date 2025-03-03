//
//  Challenge.swift
//  StepUp
//
//  Created by Hugo Blas on 27/02/2025.
//

struct Challenge {
    let creatorUserID: String
    let participantsUserID: [Participant]
    let name: String
    let description: String
    let goal: Goal
    let duration: Int

    func getParticipantProgress(userID: String) -> Int {
        return participantsUserID.first(where: { $0.userID == userID })!.progress
    }
}
