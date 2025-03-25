//
//  UserChallengesService.swift
//  StepUp
//
//  Created by Hugo Blas on 24/03/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class UserChallengesService: ObservableObject {
    @Published var challenges: [Challenge] = []

    func createChallenge(_ challenge: Challenge) async {

    }

    func editChallenge(_ challenge: Challenge) async {
        
    }

    private func fetchChallenges() async {
        self.challenges = []
    }

}
