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

    var body: some View {
        TabView {
            NavigationStack {
                HomeScreen().environmentObject(authenticationService)
            }
            .tabItem {
                Image(systemName: "house")
                Text(LocalizedStringKey("home"))
            }

            NavigationStack {
                ChallengesScreen()
            }
            .tabItem {
                Image(systemName: "rosette")
                Text(LocalizedStringKey("challenges"))
            }

            NavigationStack {
                ProfileScreen()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text(LocalizedStringKey("profile"))
            }
        }
    }
}

#Preview {
    AppMainView()
}
