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
                Text(LocalizedStringKey("home"))
            }

            NavigationStack {
                ChallengesScreen()
                    .environmentObject(authenticationService)
                    .environmentObject(challengesService)
                    .navigationTitle(Text(LocalizedStringKey("challenges")))
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                shouldShowChallengesSheet.toggle()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                            }
                            .sheet(isPresented: $shouldShowChallengesSheet) {
                                ChallengeCreationSheet(closeCallback: closeBottomSheet)
                                    .presentationDetents([.large])
                                    .environmentObject(challengesService)
                                    .environmentObject(authenticationService)
                            }
                        }
                    }
            }
            .tabItem {
                Image(systemName: "rosette")
                Text(LocalizedStringKey("challenges"))
            }
            .navigationTitle(Text(LocalizedStringKey("challenges")))
            .navigationBarTitleDisplayMode(.large)

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
                Text(LocalizedStringKey("profile"))
            }

        }
    }
}
