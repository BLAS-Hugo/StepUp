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
                HStack(spacing: 16) {
                    ZStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .padding(.all, 16)
                    }
                    .background(Color.appMediumGray.opacity(0.5))
                    .clipShape(Circle())
                    VStack(alignment: .leading) {
                        if let email = authenticationService.currentUserSession?.email {
                            Text(email)
                        }
                        Text("blas.hugo.dev@gmail.com")
                            .foregroundStyle(.black)
                            .font(.caption)

                        Text(authenticationService.currentUser?.firstName ?? "Hugo")
                            .bold()
                    }
                }
                .frame(maxWidth: geometry.size.width, maxHeight: 96, alignment: .leading)
                .padding(.horizontal, 16)
                VStack(spacing: 10) {
                    SettingCard(title: "Mon compte", callback: emptyCallback)
                    SettingCard(title: "Mon historique de challenges", callback: emptyCallback)
                    SettingCard(title: "Politique de confidentialités", callback: emptyCallback)
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
        .navigationTitle(Text(LocalizedStringKey("profile")))
        .navigationBarTitleDisplayMode(.large)
}
