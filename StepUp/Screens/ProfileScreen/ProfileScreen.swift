//
//  ProfileScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 21/03/2025.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var challengesService: UserChallengesService
    @EnvironmentObject var goalViewModel: GoalViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 16) {
                    ZStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .padding(.all, 16)
                            .accessibilityLabel(LocalizedStringKey("profile"))
                    }
                    .background(Color.appMediumGray.opacity(0.5))
                    .clipShape(Circle())
                    VStack(alignment: .leading) {
                        if let email = authenticationViewModel.currentUserEmail {
                            Text(email)
                                .foregroundStyle(.black)
                                .font(.caption)
                        }
                        Text(authenticationViewModel.currentUser?.firstName ?? "first_name")
                            .bold()
                    }
                }
                .frame(maxWidth: geometry.size.width, maxHeight: 96, alignment: .leading)
                .padding(.horizontal, 16)
                VStack(spacing: 10) {
                    NavigationLink {
                        AccountScreen()
                            .environmentObject(authenticationViewModel)
                            .environmentObject(challengesService)
                            .navigationTitle(Text(LocalizedStringKey("my_account")))
                            .navigationBarTitleDisplayMode(.large)
                    } label: {
                        SettingCard(title: LocalizedStringKey("my_account"))
                            .padding(.top, 16)
                    }
                    NavigationLink {
                        ObjectivesScreen()
                            .environmentObject(goalViewModel)
                            .navigationTitle(Text(LocalizedStringKey("my_objectives")))
                            .navigationBarTitleDisplayMode(.large)
                    } label: {
                        SettingCard(title: LocalizedStringKey("my_objectives"))
                    }
                    if challengesService.userChallengesHistory.count > 0 {
                        NavigationLink {
                            ChallengeListScreen(challenges: challengesService.userChallengesHistory)
                                .environmentObject(authenticationViewModel)
                                .navigationTitle(Text(LocalizedStringKey("challenge_history")))
                                .navigationBarTitleDisplayMode(.large)
                        } label: {
                            SettingCard(title: LocalizedStringKey("challenge_history"))
                        }
                    }
                    SettingCard(title: LocalizedStringKey("privacy_policy"))
                    Button {
                        authenticationViewModel.signOut()
                    } label: {
                        SettingCard(title: LocalizedStringKey("disconnect"))
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .background(Color.appLightGray)
            }
            .frame(height: geometry.size.height, alignment: .top)
        }
    }
}
