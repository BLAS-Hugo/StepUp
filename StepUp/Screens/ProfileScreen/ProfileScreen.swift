//
//  ProfileScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 21/03/2025.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    @EnvironmentObject var objectivesViewModel: ObjectivesViewModel

    @State private var navigateToObjectives = false

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
                                .foregroundStyle(.black)
                                .font(.caption)
                        }
                        Text(authenticationService.currentUser!.firstName)
                            .bold()
                    }
                }
                .frame(maxWidth: geometry.size.width, maxHeight: 96, alignment: .leading)
                .padding(.horizontal, 16)
                VStack(spacing: 10) {
                    SettingCard(title: "Mon compte", callback: emptyCallback)
                        .padding(.top, 16)
                    SettingCard(title: "Mes objectifs", callback: onObjectivesButtonTap)
                        .navigationDestination(isPresented: $navigateToObjectives) {
                        ObjectivesScreen()
                            .environmentObject(objectivesViewModel)
                            .navigationTitle(Text("Mes objectifs"))
                            .navigationBarTitleDisplayMode(.large)
                            .onDisappear {
                                navigateToObjectives = false
                            }
                        }
                    SettingCard(title: "Mon historique de challenges", callback: emptyCallback)
                    SettingCard(title: "Politique de confidentialités", callback: emptyCallback)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .background(Color.appLightGray)
            }
            .frame(height: geometry.size.height, alignment: .top)
        }
    }
    private func onObjectivesButtonTap() {
        navigateToObjectives = true
    }
}
