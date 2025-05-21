//
//  RegisterScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 20/03/2025.
//

import SwiftUI

struct RegisterScreen: View {
    @State private var email: String = ""
    @State private var isEmailValid: Bool = true
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordValid: Bool = true
    @State private var isPasswordEqual: Bool = true
    @State private var firstName: String = ""
    @State private var name: String = ""

    @State private var isButtonLoading = false

    @EnvironmentObject var authenticationService: FirebaseAuthProvider

    init(prefilledEmail: String = "") {
        _email = State(initialValue: prefilledEmail)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(Color.primaryOrange)
            VStack(alignment: .leading) {
                Text("Step up")
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, 64)
                    .padding(.leading, 32)
                VStack(spacing: 10) {
                    Text(LocalizedStringKey("signing_up"))
                        .font(.title2)
                        .bold()
                        .offset(x: -96, y: -16)
                    VStack(alignment: .leading) {
                        InputView(
                            text: $email,
                            placeholder: LocalizedStringKey("email"),
                            errorText: LocalizedStringKey("email_not_valid"),
                            shouldHideErrorText: isEmailValid,
                            shouldUseAutoCapitalization: false
                        )
                        InputView(
                            text: $firstName,
                            placeholder: LocalizedStringKey("first_name")
                        )
                        InputView(
                            text: $name,
                            placeholder: LocalizedStringKey("name")
                        )
                        InputView(
                            text: $password,
                            placeholder: LocalizedStringKey("password"),
                            errorText: LocalizedStringKey("password_not_valid"),
                            isSecureField: true,
                            shouldHideErrorText: isPasswordValid
                        )
                        InputView(
                            text: $confirmPassword,
                            placeholder: LocalizedStringKey("confirm_password"),
                            errorText: LocalizedStringKey("password_not_equal"),
                            isSecureField: true,
                            shouldHideErrorText: isPasswordEqual,
                            shouldDisplayObscuringIcon: false
                        )
                    }
                    Button {
                        Task {
                            isButtonLoading = true
                            await onSignupButtonTap()
                            isButtonLoading = false
                        }
                    } label: {
                        if isButtonLoading {
                            ProgressView()
                        } else {
                            Text(LocalizedStringKey("signup"))
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .foregroundStyle(.white)
                        }
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1 : 0.5)
                    .frame(minWidth: 135, minHeight: 64)
                    .background(Color.primaryOrange)
                    .clipShape(.rect(cornerRadius: 8))

                    // Other connection methods
                    // Google
                }
                .ignoresSafeArea()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: UIScreen.main.bounds.size.height * 0.65,
                    alignment: .top
                )
                .padding(.top, 64)
                .background(Color.appLightGray)
                .clipShape(.rect(cornerRadius: 24))
            }
        }
        .ignoresSafeArea()
        .frame(alignment: .bottom)
    }

    private func onSignupButtonTap() async {
        isButtonLoading = true
        isPasswordEqual = password == confirmPassword

        try? await authenticationService.signUp(
            email: email,
            password: password,
            firstName: firstName,
            name: name
        )
        isButtonLoading = false
    }
}

extension RegisterScreen: AuthenticationFormProtocol {
    var isFormValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !firstName.isEmpty
        && !name.isEmpty
        && !password.isEmpty
        && password.count >= 6
        && !confirmPassword.isEmpty
        && confirmPassword.count >= 6
        && password == confirmPassword
    }
}
