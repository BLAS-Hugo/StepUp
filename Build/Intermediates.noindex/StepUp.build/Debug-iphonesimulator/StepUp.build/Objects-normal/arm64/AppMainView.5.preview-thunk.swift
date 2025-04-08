import func SwiftUI.__designTimeSelection

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
        return __designTimeSelection(UserChallengesService(authenticationService: __designTimeSelection(authenticationService, "#5902.[1].[2].property.[0].[0].arg[0].value")), "#5902.[1].[2].property.[0].[0]")
    }

    var body: some View {
        __designTimeSelection(TabView {
            __designTimeSelection(NavigationStack {
                __designTimeSelection(HomeScreen()
                    .environmentObject(__designTimeSelection(authenticationService, "#5902.[1].[3].property.[0].[0].arg[0].value.[0].arg[0].value.[0].modifier[0].arg[0].value"))
                    .environmentObject(__designTimeSelection(challengesService, "#5902.[1].[3].property.[0].[0].arg[0].value.[0].arg[0].value.[0].modifier[1].arg[0].value"))
                    .navigationTitle(__designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#5902_0", fallback: "home")), "#5902.[1].[3].property.[0].[0].arg[0].value.[0].arg[0].value.[0].modifier[2].arg[0].value.arg[0].value")), "#5902.[1].[3].property.[0].[0].arg[0].value.[0].arg[0].value.[0].modifier[2].arg[0].value"))
                    .navigationBarTitleDisplayMode(.large), "#5902.[1].[3].property.[0].[0].arg[0].value.[0].arg[0].value.[0]")
            }
            .tabItem {
                __designTimeSelection(Image(systemName: __designTimeString("#5902_1", fallback: "house")), "#5902.[1].[3].property.[0].[0].arg[0].value.[0].modifier[0].arg[0].value.[0]")
                __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#5902_2", fallback: "home")), "#5902.[1].[3].property.[0].[0].arg[0].value.[0].modifier[0].arg[0].value.[1].arg[0].value")), "#5902.[1].[3].property.[0].[0].arg[0].value.[0].modifier[0].arg[0].value.[1]")
            }, "#5902.[1].[3].property.[0].[0].arg[0].value.[0]")

            __designTimeSelection(NavigationStack {
                __designTimeSelection(ChallengesScreen()
                    .navigationTitle(__designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#5902_3", fallback: "challenges")), "#5902.[1].[3].property.[0].[0].arg[0].value.[1].arg[0].value.[0].modifier[0].arg[0].value.arg[0].value")), "#5902.[1].[3].property.[0].[0].arg[0].value.[1].arg[0].value.[0].modifier[0].arg[0].value"))
                    .navigationBarTitleDisplayMode(.large), "#5902.[1].[3].property.[0].[0].arg[0].value.[1].arg[0].value.[0]")
            }
            .tabItem {
                __designTimeSelection(Image(systemName: __designTimeString("#5902_4", fallback: "rosette")), "#5902.[1].[3].property.[0].[0].arg[0].value.[1].modifier[0].arg[0].value.[0]")
                __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#5902_5", fallback: "challenges")), "#5902.[1].[3].property.[0].[0].arg[0].value.[1].modifier[0].arg[0].value.[1].arg[0].value")), "#5902.[1].[3].property.[0].[0].arg[0].value.[1].modifier[0].arg[0].value.[1]")
            }
            .navigationTitle(__designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#5902_6", fallback: "challenges")), "#5902.[1].[3].property.[0].[0].arg[0].value.[1].modifier[1].arg[0].value.arg[0].value")), "#5902.[1].[3].property.[0].[0].arg[0].value.[1].modifier[1].arg[0].value"))
            .navigationBarTitleDisplayMode(.large), "#5902.[1].[3].property.[0].[0].arg[0].value.[1]")

            __designTimeSelection(NavigationStack {
                __designTimeSelection(ProfileScreen()
                    .navigationTitle(__designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#5902_7", fallback: "profile")), "#5902.[1].[3].property.[0].[0].arg[0].value.[2].arg[0].value.[0].modifier[0].arg[0].value.arg[0].value")), "#5902.[1].[3].property.[0].[0].arg[0].value.[2].arg[0].value.[0].modifier[0].arg[0].value"))
                    .navigationBarTitleDisplayMode(.large), "#5902.[1].[3].property.[0].[0].arg[0].value.[2].arg[0].value.[0]")
            }
            .tabItem {
                __designTimeSelection(Image(systemName: __designTimeString("#5902_8", fallback: "person.fill")), "#5902.[1].[3].property.[0].[0].arg[0].value.[2].modifier[0].arg[0].value.[0]")
                __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#5902_9", fallback: "profile")), "#5902.[1].[3].property.[0].[0].arg[0].value.[2].modifier[0].arg[0].value.[1].arg[0].value")), "#5902.[1].[3].property.[0].[0].arg[0].value.[2].modifier[0].arg[0].value.[1]")
            }, "#5902.[1].[3].property.[0].[0].arg[0].value.[2]")
        }, "#5902.[1].[3].property.[0].[0]")
    }
}

#Preview {
    AppMainView().environmentObject(AuthenticationService())
}
