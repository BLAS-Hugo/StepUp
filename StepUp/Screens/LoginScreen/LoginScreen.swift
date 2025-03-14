//
//  LoginScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 04/03/2025.
//

import SwiftUI

struct LoginScreen: View {

    @State private var email: String = ""
    @State private var isEmailValid: Bool = true
    @State private var password: String = ""
    @State private var isPasswordValid: Bool = true

    @State private var shouldDisplaySignInPage: Bool = false
    @State private var shouldRememberUser: Bool = true

    @State private var isButtonLoading = false

    private let controller = LoginViewController()

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
                VStack (spacing: 10) {
                    Text(LocalizedStringKey("welcome"))
                        .font(.title2)
                        .bold()
                        .offset(x: -96, y: -16)
                    VStack(alignment: .leading) {
                        InputView(
                            text: $email,
                            placeholder: LocalizedStringKey("email"),
                            errorText: LocalizedStringKey("email_not_valid"),
                            shouldHideErrorText: true//email.isEmpty || !isEmailValid
                        )
                        InputView(
                            text: $password,
                            placeholder: LocalizedStringKey("password"),
                            errorText: LocalizedStringKey("password_not_valid"),
                            isSecureField: true,
                            shouldHideErrorText: true//password.isEmpty || !isPasswordValid
                        )
                    }


                    // Remember me button


                    Button {
                        // Call sign up function
                        if shouldDisplaySignInPage {
                            onSigninButtonTap()
                        } else {
                            Task {
                                await onSignupButtonTap()
                            }
                        }
                    } label: {
                        if isButtonLoading {
                            ProgressView()
                        } else {
                            Text(shouldDisplaySignInPage ? LocalizedStringKey("signin") : LocalizedStringKey("signup"))
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(minWidth: 135, minHeight: 64)
                    .background(Color.primaryOrange)
                    .clipShape(.rect(cornerRadius: 8))
                    Button {
                        // Change view to sign in page
                        shouldDisplaySignInPage.toggle()
                        email = ""
                        password = ""
                    } label: {
                        Text(shouldDisplaySignInPage ? LocalizedStringKey("not_registered_signup") : LocalizedStringKey("already_registered_signin"))
                            .font(.system(size: 16, design: .rounded))
                            .underline()
                            .foregroundStyle(Color.primaryOrange)
                    }

                    // Other connection methods
                    // Google
                }
                .ignoresSafeArea()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: UIScreen.main.bounds.size.height * 0.6,
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
        await controller.registerUser(
            email: email,
            password: password,
            onInvalidPassword: { isPasswordValid = false },
            onInvalidEmail: { isEmailValid = false }
        )
        isButtonLoading = false
    }
    private func onSigninButtonTap() {
        isButtonLoading = true
        controller.login(
            email: email,
            password: password,
            onInvalidPassword: { isPasswordValid = false },
            onInvalidEmail: { isEmailValid = false }
        )
        isButtonLoading = false
    }
}

extension View {
    func placeholder<Content: View>(
        when condition: Bool,
        @ViewBuilder placeholder: () -> Content) -> some View {

            ZStack(alignment: .leading) {
                if condition {
                    placeholder()
                }
                self
            }
        }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}

#Preview {
    LoginScreen()
}
