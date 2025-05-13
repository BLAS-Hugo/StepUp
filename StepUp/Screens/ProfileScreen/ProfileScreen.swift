//
//  ProfileScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 21/03/2025.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    @EnvironmentObject var challengesService: UserChallengesService
    @EnvironmentObject var objectivesViewModel: ObjectivesViewModel

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
                                .foregroundStyle(.black)
                                .font(.caption)
                        }
                        Text(authenticationService.currentUser?.firstName ?? "Prénom")
                            .bold()
                    }
                }
                .frame(maxWidth: geometry.size.width, maxHeight: 96, alignment: .leading)
                .padding(.horizontal, 16)
                VStack(spacing: 10) {
                    SettingCard(title: "Mon compte")
                        .padding(.top, 16)
                    NavigationLink {
                        ObjectivesScreen()
                            .environmentObject(objectivesViewModel)
                            .navigationTitle(Text("Mes objectifs"))
                            .navigationBarTitleDisplayMode(.large)
                    } label: {
                        SettingCard(title: "Mes objectifs")
                    }
                    if challengesService.userChallengesHistory.count > 0 {
                        NavigationLink {
                            ChallengeListScreen(challenges: challengesService.userChallengesHistory)
                                .environmentObject(authenticationService)
                                .navigationTitle(Text("Historique de challenges"))
                                .navigationBarTitleDisplayMode(.large)
                        } label: {
                            SettingCard(title: "Mon historique de challenges")
                        }
                    }
                    SettingCard(title: "Politique de confidentialités")
                    Button {
                        authenticationService.signOut()
                    } label: {
                        SettingCard(title: "Déconnexion")
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .background(Color.appLightGray)
            }
            .frame(height: geometry.size.height, alignment: .top)
        }
    }
}
