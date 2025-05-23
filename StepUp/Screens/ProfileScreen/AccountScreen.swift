//
//  AccountScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 23/05/2025.
//

import SwiftUI

struct AccountScreen: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var challengesService: UserChallengesService

    @State private var name: String = ""
    @State private var canEditName: Bool = false
    @State private var firstName: String = ""
    @State private var canEditFirstName: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

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
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizedStringKey("name"))
                        HStack {
                            TextField(name, text: $name)
                                .disabled(!canEditName)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.words)
                                .onSubmit {
                                    canEditName.toggle()
                                }
                                .padding(.all, 8)
                                .background(Color.appWhite)
                                .clipShape(.rect(cornerRadius: 8))
                            if !canEditName {
                                Button {
                                    canEditName.toggle()
                                } label: {
                                    Image(systemName: "pencil")
                                        .foregroundStyle(Color.appDarkGray)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizedStringKey("first_name"))
                        HStack {
                            TextField(firstName, text: $firstName)
                                .disabled(!canEditFirstName)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.words)
                                .onSubmit {
                                    canEditFirstName.toggle()
                                }
                                .padding(.all, 8)
                                .background(Color.appWhite)
                                .clipShape(.rect(cornerRadius: 8))
                            if !canEditFirstName {
                                Button {
                                    canEditFirstName.toggle()
                                } label: {
                                    Image(systemName: "pencil")
                                        .foregroundStyle(Color.appDarkGray)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    Button {
                        Task {
                            do {
                                try await authenticationViewModel.deleteAccount()
                            } catch {
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    } label: {
                        SettingCard(title: LocalizedStringKey("delete_account"))
                    }
                    Spacer()
                    Button(LocalizedStringKey("confirm")) {
                        Task {
                            await updateUserData()
                        }
                    }
                    .frame(minWidth: 135, minHeight: 64)
                    .background(Color.primaryOrange)
                    .clipShape(.rect(cornerRadius: 8))
                }
                .padding(.vertical, 16)
                .frame(maxHeight: .infinity, alignment: .top)
                .background(Color.appLightGray)
            }
            .frame(height: geometry.size.height, alignment: .top)
        }
        .onAppear {
            name = authenticationViewModel.currentUser?.name ?? ""
            firstName = authenticationViewModel.currentUser?.firstName ?? ""
        }
        .alert(LocalizedStringKey("network_error"), isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                showAlert.toggle()
            }
        } message: {
            Text(alertMessage)
        }
    }

    private func updateUserData() async {
        guard let currentUser = authenticationViewModel.currentUser else { return }

        do {
            try await authenticationViewModel.updateUserData(name: name, firstName: firstName)

            try await challengesService.updateUserNameInAllChallenges(for: currentUser, newFirstName: firstName)

            canEditName = false
            canEditFirstName = false
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}
