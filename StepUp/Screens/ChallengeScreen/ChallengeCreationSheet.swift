//
//  ChallengeCreationSheet.swift
//  StepUp
//
//  Created by Hugo Blas on 25/04/2025.
//

import SwiftUI

struct ChallengeCreationSheet: View {
    @Environment(\.sizeCategory) var sizeCategory

    let closeCallback: () -> Void
    @EnvironmentObject var challengesService: UserChallengesService
    @EnvironmentObject var authenticationService: AuthenticationViewModel
    @State private var challengeName: String = ""
    @State private var challengeDescription: String = ""
    @State private var challengeDate: Date = Date()
    @State private var challengeEndDate: Date = Date()
    @State private var challengeGoal: String = "0"
    @State private var challengeGoalType = 0

    @State private var showCreationErrorAlert: Bool = false
    @State private var showDatesErrorAlert: Bool = false

    private var canCreateChallenge: Bool {
        !challengeName.isEmpty && !challengeDescription.isEmpty && Int(challengeGoal) != nil && Int(challengeGoal)! > 0
    }

    var body: some View {
        ScrollView {
                VStack(spacing: 32) {
                    Text(LocalizedStringKey("create_challenge"))
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(LocalizedStringKey("challenge_name"))
                                .font(.body)
                                .scaledToFill()
                            TextField("", text: $challengeName)
                                .textFieldStyle(.roundedBorder)
                                .accessibilityLabel(LocalizedStringKey("challenge_name"))
                                .font(.body)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text(LocalizedStringKey("challenge_description"))
                                .font(.body)
                                .scaledToFill()
                            TextField("", text: $challengeDescription)
                                .textFieldStyle(.roundedBorder)
                                .accessibilityLabel(LocalizedStringKey("challenge_description"))
                                .font(.body)
                        }
                        DatePicker(
                            LocalizedStringKey("challenge_start_date"),
                            selection: $challengeDate,
                            displayedComponents: [.date]
                        )
                        DatePicker(
                            LocalizedStringKey("challenge_end_date"),
                            selection: $challengeEndDate,
                            displayedComponents: [.date]
                        )
                        VStack(alignment: .leading, spacing: 8) {
                            Text(LocalizedStringKey("challenge_goal"))
                            Picker(LocalizedStringKey("challenge_type"), selection: $challengeGoalType) {
                                Text(LocalizedStringKey("distance")).tag(0)
                                Text(LocalizedStringKey("steps")).tag(1)
                            }
                            .pickerStyle(.segmented)
                            HStack {
                                TextField("", text: $challengeGoal)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                                if challengeGoalType == 0 {
                                    Text("KM")
                                        .font(.body)
                                        .scaledToFill()
                                }
                            }
                        }
                    }
                    Button {
                        Task {
                            await createChallenge()
                        }
                    } label: {
                        Text(LocalizedStringKey("confirm"))
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
        .alert(LocalizedStringKey("network_error"), isPresented: $showCreationErrorAlert) {
            Button("OK", role: .cancel) {
                showCreationErrorAlert.toggle()
            }
        } message: {
            Text(LocalizedStringKey("network_error_message"))
        }
        .alert(LocalizedStringKey("invalid_dates_error"), isPresented: $showDatesErrorAlert) {
            Button("OK", role: .cancel) {
                showDatesErrorAlert.toggle()
            }
        } message: {
            Text(LocalizedStringKey("invalid_dates_error_message"))
        }
    }

    private func createChallenge() async {
        if !challengesService.areChallengeDatesValid(from: challengeDate, to: challengeEndDate) {
            showDatesErrorAlert.toggle()
            return
        }

        let goal = challengeGoalType == 0
        ? Goal(distance: (Int(challengeGoal) ?? 0) * 1000, steps: nil)
        : Goal(distance: nil, steps: Int(challengeGoal))
        let duration = challengeEndDate.timeIntervalSince(challengeDate).rounded(.towardZero)
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
            showCreationErrorAlert.toggle()
        }
        closeCallback()
    }
}
