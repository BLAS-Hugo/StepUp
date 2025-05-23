//
//  LoginScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 04/03/2025.
//

import SwiftUI

protocol AuthenticationFormProtocol {
    var isFormValid: Bool { get }
}

struct LoginScreen: View {
    @State private var email: String = ""
    @State private var isEmailValid: Bool = true
    @State private var password: String = ""
    @State private var isPasswordValid: Bool = true

    @State private var shouldDisplaySignInPage: Bool = false
    @State private var shouldRememberUser: Bool = true

    @State private var isButtonLoading = false

    @State private var showAlert = false
    @State private var showNetworkErrorAlert = false
    @State private var showPasswordErrorAlert = false
    @State private var navigateToRegister = false

    @EnvironmentObject var authenticationService: FirebaseAuthProvider

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
                    Text(LocalizedStringKey("welcome"))
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
                        .onChange(of: email) { _, newValue in
                                        if !newValue.isEmpty {
                                            isEmailValid = isValidEmail(newValue)
                                        } else {
                                            isEmailValid = true
                                        }
                                    }
                        if shouldDisplaySignInPage {
                            InputView(
                                text: $password,
                                placeholder: LocalizedStringKey("password"),
                                errorText: LocalizedStringKey("password_not_valid"),
                                isSecureField: true,
                                shouldHideErrorText: isPasswordValid
                            )
                            .onChange(of: password) { _, newValue in
                                            if !newValue.isEmpty {
                                                isPasswordValid = isValidPassword(newValue)
                                            } else {
                                                isPasswordValid = true
                                            }
                                        }
                        }
                    }

                    if shouldDisplaySignInPage {
                    Button {
                        Task {
                            await onSigninButtonTap()
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
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1 : 0.5)
                    .frame(minWidth: 135, minHeight: 64)
                    .background(Color.primaryOrange)
                    .clipShape(.rect(cornerRadius: 8))
                    } else {
                        Button {
                            if email.isEmpty {
                                isEmailValid = false
                                showAlert = true
                            } else {
                                navigateToRegister = true
                            }
                        } label: {
                            Text(LocalizedStringKey("signup"))
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .foregroundStyle(.white)
                        }
                        .frame(minWidth: 135, minHeight: 64)
                        .background(Color.primaryOrange)
                        .clipShape(.rect(cornerRadius: 8))
                        .disabled(email.isEmpty)
                        .navigationDestination(isPresented: $navigateToRegister) {
                            RegisterScreen(prefilledEmail: email)
                                .environmentObject(authenticationService)
                        }
                    }
                    Button {
                        shouldDisplaySignInPage.toggle()
                        email = ""
                        password = ""
                    } label: {
                        Text(shouldDisplaySignInPage
                        ? LocalizedStringKey("not_registered_signup")
                        : LocalizedStringKey("already_registered_signin"))
                            .font(.system(size: 16, design: .rounded))
                            .underline()
                            .foregroundStyle(Color.primaryOrange)
                    }
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
        .alert(LocalizedStringKey("email_required"), isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(LocalizedStringKey("email_required_message"))
        }
        .alert(LocalizedStringKey("network_error"), isPresented: $showNetworkErrorAlert) {
            Button("OK", role: .cancel) {
                showNetworkErrorAlert.toggle()
            }
        } message: {
            Text(LocalizedStringKey("network_error_message"))
        }
        .alert(LocalizedStringKey("password_error"), isPresented: $showPasswordErrorAlert) {
            Button("OK", role: .cancel) {
                showPasswordErrorAlert.toggle()
            }
        } message: {
            Text(LocalizedStringKey("password_error_message"))
        }
    }

    private func onSigninButtonTap() async {
        isButtonLoading = true
        do {
            try await authenticationService.signIn(
                withEmail: email,
                password: password
            )
        } catch {
            if error.localizedDescription.contains("auth credential") {
                showPasswordErrorAlert.toggle()
            } else {
                showNetworkErrorAlert.toggle()
            }
        }
        isButtonLoading = false
    }
}

extension LoginScreen: AuthenticationFormProtocol {
    private func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }

    private func isValidPassword(_ password: String) -> Bool {
            guard password.count >= 6 else { return false }

            let uppercaseRegex = ".*[A-Z]+.*"
            let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex)
            guard uppercasePredicate.evaluate(with: password) else { return false }

            let lowercaseRegex = ".*[a-z]+.*"
            let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", lowercaseRegex)
            guard lowercasePredicate.evaluate(with: password) else { return false }

            return true
        }

    var isFormValid: Bool {
        return !email.isEmpty
        && isEmailValid
        && !password.isEmpty
        && isPasswordValid
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
