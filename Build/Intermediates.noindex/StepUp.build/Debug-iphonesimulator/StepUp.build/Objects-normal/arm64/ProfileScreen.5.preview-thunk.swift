import func SwiftUI.__designTimeSelection

import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Volumes/SSD Mac/Dev/Open Classroom/projet libre/StepUp/StepUp/Screens/ProfileScreen/ProfileScreen.swift", line: 1)
//
//  ProfileScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 21/03/2025.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var authenticationService: AuthenticationService

    func emptyCallback() {

    }

    var body: some View {
        __designTimeSelection(GeometryReader { geometry in
            __designTimeSelection(VStack {
                __designTimeSelection(HStack(spacing: __designTimeInteger("#6793_0", fallback: 16)) {
                    __designTimeSelection(ZStack {
                        __designTimeSelection(Image(systemName: __designTimeString("#6793_1", fallback: "person.fill"))
                            .resizable()
                            .frame(width: __designTimeInteger("#6793_2", fallback: 48), height: __designTimeInteger("#6793_3", fallback: 48))
                            .padding(.all, __designTimeInteger("#6793_4", fallback: 16)), "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[0].arg[0].value.[0]")
                    }
                    .background(__designTimeSelection(Color.appMediumGray.opacity(__designTimeFloat("#6793_5", fallback: 0.5)), "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[0].modifier[0].arg[0].value"))
                    .clipShape(__designTimeSelection(Circle(), "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[0].modifier[1].arg[0].value")), "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[0]")
                    __designTimeSelection(VStack(alignment: .leading) {
                        if let email = authenticationService.currentUserSession?.email {
                            __designTimeSelection(Text(__designTimeSelection(email, "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[0].[0].[0].arg[0].value")), "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[0].[0].[0]")
                        }
                        __designTimeSelection(Text(__designTimeString("#6793_6", fallback: "blas.hugo.dev@gmail.com"))
                            .foregroundStyle(.black)
                            .font(.caption), "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[1]")

                        __designTimeSelection(Text(authenticationService.currentUser?.firstName ?? __designTimeString("#6793_7", fallback: "Hugo"))
                            .bold(), "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[2]")
                    }, "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[1]")
                }
                .frame(maxWidth: __designTimeSelection(geometry.size.width, "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[0].modifier[0].arg[0].value"), maxHeight: __designTimeInteger("#6793_8", fallback: 96), alignment: .leading)
                .padding(.horizontal, __designTimeInteger("#6793_9", fallback: 16)), "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[0]")
                __designTimeSelection(VStack(spacing: __designTimeInteger("#6793_10", fallback: 10)) {
                    __designTimeSelection(SettingCard(title: __designTimeString("#6793_11", fallback: "Mon historique de challenges"), callback: __designTimeSelection(emptyCallback, "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0].arg[1].value")), "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0]")
                    __designTimeSelection(SettingCard(title: __designTimeString("#6793_12", fallback: "Mon historique de challenges"), callback: __designTimeSelection(emptyCallback, "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[1].arg[1].value")), "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[1]")
                    __designTimeSelection(SettingCard(title: __designTimeString("#6793_13", fallback: "Politique de confidentialités"), callback: __designTimeSelection(emptyCallback, "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[2].arg[1].value")), "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[2]")
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .background(__designTimeSelection(Color.appLightGray, "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[1].modifier[1].arg[0].value")), "#6793.[1].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[1]")
            }
            .frame(height: __designTimeSelection(geometry.size.height, "#6793.[1].[2].property.[0].[0].arg[0].value.[0].modifier[0].arg[0].value"), alignment: .top), "#6793.[1].[2].property.[0].[0].arg[0].value.[0]")
        }, "#6793.[1].[2].property.[0].[0]")
    }
}

#Preview {
    ProfileScreen()
        .environmentObject(AuthenticationService())
        .navigationTitle(Text(LocalizedStringKey(__designTimeString("#6793_14", fallback: "profile"))))
        .navigationBarTitleDisplayMode(.large)
}
