//
//  ChallengeCreationSheet.swift
//  StepUp
//
//  Created by Hugo Blas on 25/04/2025.
//

import SwiftUI

struct ChallengeCreationSheet: View {
    let closeCallback: () -> Void
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
                        DatePicker(
                            "Date de départ du challenge",
                            selection: $challengeDate,
                            displayedComponents: [.date]
                        )
                        DatePicker(
                            "Date de fin du challenge",
                            selection: $challengeEndDate,
                            displayedComponents: [.date]
                        )
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Objectif du challenge: ")
                            Picker("Type de challenge", selection: $challengeGoalType) {
                                Text("Distance").tag(0)
                                Text("Pas").tag(1)
                            }
                            .pickerStyle(.segmented)
                            HStack {
                                TextField("", text: $challengeGoal)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                                if challengeGoalType == 0 {
                                    Text("KM")
                                }
                            }
                        }
                    }
                    Button {
                        print(canCreateChallenge)
                        Task {
                            await createChallenge()
                        }
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

    private func createChallenge() async {
        // Check if challenge can be created
        if !challengesService.areChallengeDatesValid(from: challengeDate, to: challengeEndDate) {
            // Display error to user
            return
        }

        print("Dates are ok")
        let goal = challengeGoalType == 0
        ? Goal(distance: Int(challengeGoal) ?? 0 * 1000, steps: nil)
        : Goal(distance: nil, steps: Int(challengeGoal))
        print("Parsed goal")
        let duration = challengeEndDate.timeIntervalSince(challengeDate).rounded(.towardZero)
        print("Parsed duration")
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
        print("Parsed challenge")

        do {
            try await challengesService.createChallenge(challenge, forUser: authenticationService.currentUser)
        } catch {
            // Display error to user
        }
        closeCallback()
    }
}
