//
//  Participant.swift
//  StepUp
//
//  Created by Hugo Blas on 27/02/2025.
//

struct Participant {
    let userID: String
    let name: String
    let progress: Int
}

extension Participant: Codable {

}

extension Participant: Equatable { }
