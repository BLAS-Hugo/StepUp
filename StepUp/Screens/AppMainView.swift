//
//  AppMainView.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import SwiftUI

struct AppMainView: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    @EnvironmentObject var healthKitService: HealthKitService
    @EnvironmentObject var objectivesViewModel: ObjectivesViewModel
    @State var selection: Int = 0
    @EnvironmentObject var challengesService: UserChallengesService
    @State private var shouldShowChallengesSheet = false

    private func closeBottomSheet() {
        shouldShowChallengesSheet = false
    }

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                HomeScreen()
                    .environmentObject(authenticationService)
                    .environmentObject(challengesService)
                    .environmentObject(healthKitService)
                    .environmentObject(objectivesViewModel)
                    .navigationTitle(Text(LocalizedStringKey("home")))
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Image(systemName: "house")
                    .accessibilityLabel(LocalizedStringKey("home"))
                Text(LocalizedStringKey("home"))
            }

            NavigationStack {
                ChallengesScreen()
                    .environmentObject(authenticationService)
                    .environmentObject(challengesService)
                    .navigationTitle(Text(LocalizedStringKey("challenges")))
                    .navigationBarTitleDisplayMode(.large)
                    .sheet(isPresented: $shouldShowChallengesSheet) {
                        ChallengeCreationSheet(closeCallback: closeBottomSheet)
                            .presentationDetents([.large])
                            .environmentObject(challengesService)
                            .environmentObject(authenticationService)
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                shouldShowChallengesSheet.toggle()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .accessibilityLabel(LocalizedStringKey("create_challenge"))
                            }
                        }
                    }

            }
            .tabItem {
                Image(systemName: "rosette")
                    .accessibilityLabel(LocalizedStringKey("challenges"))
                Text(LocalizedStringKey("challenges"))
            }

            NavigationStack {
                ProfileScreen()
                    .environmentObject(authenticationService)
                    .environmentObject(objectivesViewModel)
                    .environmentObject(challengesService)
                    .navigationTitle(Text(LocalizedStringKey("profile")))
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Image(systemName: "person.fill")
                    .accessibilityLabel(LocalizedStringKey("profile"))
                Text(LocalizedStringKey("profile"))
            }

        }
    }
}
