import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Volumes/SSD Mac/Dev/Open Classroom/projet libre/StepUp/StepUp/Screens/AppMainView.swift", line: 1)
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
                    .navigationTitle(Text(LocalizedStringKey(__designTimeString("#5902_0", fallback: "home"))))
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Image(systemName: __designTimeString("#5902_1", fallback: "house"))
                Text(LocalizedStringKey(__designTimeString("#5902_2", fallback: "home")))
            }

            NavigationStack {
                ChallengesScreen()
                    .navigationTitle(Text(LocalizedStringKey(__designTimeString("#5902_3", fallback: "challenges"))))
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Image(systemName: __designTimeString("#5902_4", fallback: "rosette"))
                Text(LocalizedStringKey(__designTimeString("#5902_5", fallback: "challenges")))
            }
            .navigationTitle(Text(LocalizedStringKey(__designTimeString("#5902_6", fallback: "challenges"))))
            .navigationBarTitleDisplayMode(.large)

            NavigationStack {
                ProfileScreen()
                    .navigationTitle(Text(LocalizedStringKey(__designTimeString("#5902_7", fallback: "profile"))))
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Image(systemName: __designTimeString("#5902_8", fallback: "person.fill"))
                Text(LocalizedStringKey(__designTimeString("#5902_9", fallback: "profile")))
            }

        }
    }
}

#Preview {
    AppMainView().environmentObject(AuthenticationService())
}
