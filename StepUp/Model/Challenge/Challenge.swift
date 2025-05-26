//
//  Challenge.swift
//  StepUp
//
//  Created by Hugo Blas on 27/02/2025.
//

import Foundation

struct Challenge: Identifiable {
    let creatorUserID: String
    var participants: [Participant]
    let name: String
    let description: String
    let goal: Goal
    let duration: Int
    let date: Date
    var id: String?

    func getParticipantProgress(userID: String) -> Int? {
        return participants.first(where: { $0.userID == userID })?.progress
    }

    var endDate: Date {
        date.addingTimeInterval(TimeInterval(duration))
    }

    func addParticipant(_ user: User) -> Challenge {
        var participantsArray = participants
        participantsArray.append(Participant(userID: user.id, name: user.firstName, progress: 0))
        return Challenge(
            creatorUserID: creatorUserID,
            participants: participantsArray,
            name: name,
            description: description,
            goal: goal,
            duration: duration,
            date: date,
            id: id
        )
    }

    func editParticipantProgress(_ user: User, progress: Int) -> Challenge {
        var participantsArray = participants
        guard let participantIndex = participantsArray.firstIndex(where: { $0.userID == user.id }) else {
            return self
        }
        participantsArray[participantIndex] = Participant(userID: user.id, name: user.firstName, progress: progress)
        return Challenge(
            creatorUserID: creatorUserID,
            participants: participantsArray,
            name: name,
            description: description,
            goal: goal,
            duration: duration,
            date: date,
            id: id
        )
    }
}

extension Challenge: Codable {

}
