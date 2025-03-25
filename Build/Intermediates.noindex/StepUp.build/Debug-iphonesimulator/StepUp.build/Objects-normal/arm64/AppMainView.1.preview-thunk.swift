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

    var body: some View {
        TabView {
            NavigationStack {
                HomeScreen().environmentObject(authenticationService)
            }
            .tabItem {
                Image(systemName: __designTimeString("#10701_0", fallback: "house"))
                Text(LocalizedStringKey(__designTimeString("#10701_1", fallback: "home")))
            }

            NavigationStack {
                ChallengesScreen()
            }
            .tabItem {
                Image(systemName: __designTimeString("#10701_2", fallback: "rosette"))
                Text(LocalizedStringKey(__designTimeString("#10701_3", fallback: "challenges")))
            }

            NavigationStack {
                ProfileScreen()
            }
            .tabItem {
                Image(systemName: __designTimeString("#10701_4", fallback: "person.fill"))
                Text(LocalizedStringKey(__designTimeString("#10701_5", fallback: "profile")))
            }
        }
    }
}

#Preview {
    AppMainView()
}
