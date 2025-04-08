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
        GeometryReader { geometry in
            VStack {
                HStack(spacing: __designTimeInteger("#6793_0", fallback: 16)) {
                    ZStack {
                        Image(systemName: __designTimeString("#6793_1", fallback: "person.fill"))
                            .resizable()
                            .frame(width: __designTimeInteger("#6793_2", fallback: 48), height: __designTimeInteger("#6793_3", fallback: 48))
                            .padding(.all, __designTimeInteger("#6793_4", fallback: 16))
                    }
                    .background(Color.appMediumGray.opacity(__designTimeFloat("#6793_5", fallback: 0.5)))
                    .clipShape(Circle())
                    VStack(alignment: .leading) {
                        if let email = authenticationService.currentUserSession?.email {
                            Text(email)
                        }
                        Text(__designTimeString("#6793_6", fallback: "blas.hugo.dev@gmail.com"))
                            .foregroundStyle(.black)
                            .font(.caption)

                        Text(authenticationService.currentUser?.firstName ?? __designTimeString("#6793_7", fallback: "Hugo"))
                            .bold()
                    }
                }
                .frame(maxWidth: geometry.size.width, maxHeight: __designTimeInteger("#6793_8", fallback: 96), alignment: .leading)
                .padding(.horizontal, __designTimeInteger("#6793_9", fallback: 16))
                VStack(spacing: __designTimeInteger("#6793_10", fallback: 10)) {
                    SettingCard(title: __designTimeString("#6793_11", fallback: "Mon historique de challenges"), callback: emptyCallback)
                    SettingCard(title: __designTimeString("#6793_12", fallback: "Mon historique de challenges"), callback: emptyCallback)
                    SettingCard(title: __designTimeString("#6793_13", fallback: "Politique de confidentialités"), callback: emptyCallback)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .background(Color.appLightGray)
            }
            .frame(height: geometry.size.height, alignment: .top)
        }
    }
}

#Preview {
    ProfileScreen()
        .environmentObject(AuthenticationService())
        .navigationTitle(Text(LocalizedStringKey(__designTimeString("#6793_14", fallback: "profile"))))
        .navigationBarTitleDisplayMode(.large)
}
