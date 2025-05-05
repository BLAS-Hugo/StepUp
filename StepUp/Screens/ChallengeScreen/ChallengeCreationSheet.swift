//
//  ChallengeCreationSheet.swift
//  StepUp
//
//  Created by Hugo Blas on 25/04/2025.
//

import SwiftUI

struct ChallengeCreationSheet: View {
    @EnvironmentObject var challengesService: UserChallengesService
    @EnvironmentObject var authenticationService: AuthenticationService
    @State private var challengeName: String = ""
    @State private var challengeDescription: String = ""
    @State private var challengeDate: Date = Date()
    @State private var challengeEndDate: Date = Date()
    @State private var challengeGoal: String = "0"
    @State private var challengeGoalType = 0

    private var canCreateChallenge: Bool {
        !challengeName.isEmpty && !challengeDescription.isEmpty && Int(challengeGoal) != nil && Int(challengeGoal)! > 0
    }

    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                VStack(spacing: 32) {
                    Text("Créer un nouveau Challenge")
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nom du challenge")
                            TextField("", text: $challengeName)
                                .textFieldStyle(.roundedBorder)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description du challenge")
                            TextField("", text: $challengeDescription)
                                .textFieldStyle(.roundedBorder)
                        }
                        DatePicker("Date de départ du challenge", selection: $challengeDate, displayedComponents: [.date])
                        DatePicker("Date de fin du challenge", selection: $challengeEndDate, displayedComponents: [.date])
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Objectif du challenge: ")
                            Picker("Type de challenge", selection: $challengeGoalType) {
                                Text("Distance").tag(0)
                                Text("Pas").tag(1)
                            }
                            .pickerStyle(.segmented)
                            TextField("", text: $challengeGoal)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    Button {
                        print("Confirm")
                    } label: {
                        Text("Confirmer")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 48)
                            .foregroundStyle(.white)
                    }
                    .disabled(!canCreateChallenge)
                    .frame(minWidth: 135, minHeight: 64, alignment: .center)
                    .background(Color.primaryOrange)
                    .clipShape(.rect(cornerRadius: 8))
                }
                .padding(.all, 32)
            }
        }
    }

    private func createChallenge() async {
        let goal = challengeGoalType == 0 ? Goal(distance: Int(challengeGoal), steps: nil) : Goal(distance: nil, steps: Int(challengeGoal))
        var duration = challengeEndDate.timeIntervalSince(challengeDate).rounded(.towardZero)

        let challenge = Challenge(
            creatorUserID: authenticationService.currentUser!.id,
            participants: [],
            name: challengeName,
            description: challengeDescription,
            goal: goal,
            duration: Int(duration),
            date: challengeDate,
            id: nil
        )

        do {
            try await challengesService.createChallenge(challenge, forUser: authenticationService.currentUser)
        } catch {
            // Display error to user
        }
    }
}
