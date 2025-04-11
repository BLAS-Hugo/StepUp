//
//  AppMainView.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import SwiftUI

struct AppMainView: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    @StateObject var healthKitService = HealthKitService()
    @StateObject var objectivesViewModel = ObjectivesViewModel()
    @State var selection: Int = 0
    var challengesService: UserChallengesService {
        return UserChallengesService(authenticationService: authenticationService)
    }

    var body: some View {
        TabView {
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
                    .navigationTitle(Text(LocalizedStringKey("challenges")))
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Image(systemName: "rosette")
                Text(LocalizedStringKey("challenges"))
            }
            .navigationTitle(Text(LocalizedStringKey("challenges")))
            .navigationBarTitleDisplayMode(.large)

            NavigationStack {
                ProfileScreen()
                    .environmentObject(objectivesViewModel)
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

#Preview {
    AppMainView().environmentObject(AuthenticationService())
}
