//
//  AppMainView.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import SwiftUI

struct AppMainView: View {
    @EnvironmentObject var authenticationService: AuthenticationService
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
