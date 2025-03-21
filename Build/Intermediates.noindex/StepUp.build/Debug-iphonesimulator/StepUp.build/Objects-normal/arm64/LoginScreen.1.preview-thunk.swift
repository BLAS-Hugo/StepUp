import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Volumes/SSD Mac/Dev/Open Classroom/projet libre/StepUp/StepUp/Screens/LoginScreen/LoginScreen.swift", line: 1)
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
    @State private var navigateToRegister = false

    @EnvironmentObject var authenticationService: AuthenticationService

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(Color.primaryOrange)
            VStack(alignment: .leading) {
                Text(__designTimeString("#1829_0", fallback: "Step up"))
                    .font(.system(size: __designTimeInteger("#1829_1", fallback: 48), weight: .bold, design: .default))
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, __designTimeInteger("#1829_2", fallback: 64))
                    .padding(.leading, __designTimeInteger("#1829_3", fallback: 32))
                VStack(spacing: __designTimeInteger("#1829_4", fallback: 10)) {
                    Text(LocalizedStringKey(__designTimeString("#1829_5", fallback: "welcome")))
                        .font(.title2)
                        .bold()
                        .offset(x: __designTimeInteger("#1829_6", fallback: -96), y: __designTimeInteger("#1829_7", fallback: -16))
                    VStack(alignment: .leading) {
                        InputView(
                            text: $email,
                            placeholder: LocalizedStringKey(__designTimeString("#1829_8", fallback: "email")),
                            errorText: LocalizedStringKey(__designTimeString("#1829_9", fallback: "email_not_valid")),
                            shouldHideErrorText: isEmailValid,
                            shouldUseAutoCapitalization: __designTimeBoolean("#1829_10", fallback: false)
                        )
                        .onChange(of: email) { oldValue, newValue in
                                        if !newValue.isEmpty {
                                            isEmailValid = isValidEmail(newValue)
                                        } else {
                                            isEmailValid = __designTimeBoolean("#1829_11", fallback: true)
                                        }
                                    }
                        if shouldDisplaySignInPage {
                            InputView(
                                text: $password,
                                placeholder: LocalizedStringKey(__designTimeString("#1829_12", fallback: "password")),
                                errorText: LocalizedStringKey(__designTimeString("#1829_13", fallback: "password_not_valid")),
                                isSecureField: __designTimeBoolean("#1829_14", fallback: true),
                                shouldHideErrorText: isPasswordValid
                            )
                            .onChange(of: password) { oldValue, newValue in
                                            if !newValue.isEmpty {
                                                isPasswordValid = isValidPassword(newValue)
                                            } else {
                                                isPasswordValid = __designTimeBoolean("#1829_15", fallback: true)
                                            }
                                        }
                        }
                    }

                    // Remember me button
                    if shouldDisplaySignInPage {
                    Button {
                        Task {
                            await onSigninButtonTap()
                        }
                    } label: {
                        if isButtonLoading {
                            ProgressView()
                        } else {
                            Text(shouldDisplaySignInPage ? LocalizedStringKey(__designTimeString("#1829_16", fallback: "signin")) : LocalizedStringKey(__designTimeString("#1829_17", fallback: "signup")))
                                .font(.system(size: __designTimeInteger("#1829_18", fallback: 20), weight: .bold, design: .rounded))
                                .padding(.vertical, __designTimeInteger("#1829_19", fallback: 12))
                                .padding(.horizontal, __designTimeInteger("#1829_20", fallback: 24))
                                .foregroundStyle(.white)
                        }
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? __designTimeInteger("#1829_21", fallback: 1) : __designTimeFloat("#1829_22", fallback: 0.5))
                    .frame(minWidth: __designTimeInteger("#1829_23", fallback: 135), minHeight: __designTimeInteger("#1829_24", fallback: 64))
                    .background(Color.primaryOrange)
                    .clipShape(.rect(cornerRadius: __designTimeInteger("#1829_25", fallback: 8)))
                    } else {
                        Button {
                            if email.isEmpty {
                                isEmailValid = __designTimeBoolean("#1829_26", fallback: false)
                                showAlert = __designTimeBoolean("#1829_27", fallback: true)
                            } else {
                                navigateToRegister = __designTimeBoolean("#1829_28", fallback: true)
                            }
                        } label: {
                            Text(LocalizedStringKey(__designTimeString("#1829_29", fallback: "signup")))
                                .font(.system(size: __designTimeInteger("#1829_30", fallback: 20), weight: .bold, design: .rounded))
                                .padding(.vertical, __designTimeInteger("#1829_31", fallback: 12))
                                .padding(.horizontal, __designTimeInteger("#1829_32", fallback: 24))
                                .foregroundStyle(.white)
                        }
                        .frame(minWidth: __designTimeInteger("#1829_33", fallback: 135), minHeight: __designTimeInteger("#1829_34", fallback: 64))
                        .background(Color.primaryOrange)
                        .clipShape(.rect(cornerRadius: __designTimeInteger("#1829_35", fallback: 8)))
                        .disabled(email.isEmpty)
                        .navigationDestination(isPresented: $navigateToRegister) {
                            RegisterScreen(prefilledEmail: email)
                                .environmentObject(authenticationService)
                                .navigationBarBackButtonHidden(__designTimeBoolean("#1829_36", fallback: true))
                        }
                    }
                    Button {
                        // Change view to sign in page
                        shouldDisplaySignInPage.toggle()
                        email = __designTimeString("#1829_37", fallback: "")
                        password = __designTimeString("#1829_38", fallback: "")
                    } label: {
                        Text(shouldDisplaySignInPage
                        ? LocalizedStringKey(__designTimeString("#1829_39", fallback: "not_registered_signup"))
                        : LocalizedStringKey(__designTimeString("#1829_40", fallback: "already_registered_signin")))
                            .font(.system(size: __designTimeInteger("#1829_41", fallback: 16), design: .rounded))
                            .underline()
                            .foregroundStyle(Color.primaryOrange)
                    }

                    // Other connection methods
                    // Google
                }
                .ignoresSafeArea()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: UIScreen.main.bounds.size.height * __designTimeFloat("#1829_42", fallback: 0.6),
                    alignment: .top
                )
                .padding(.top, __designTimeInteger("#1829_43", fallback: 64))
                .background(Color.appLightGray)
                .clipShape(.rect(cornerRadius: __designTimeInteger("#1829_44", fallback: 24)))
            }
        }
        .ignoresSafeArea()
        .frame(alignment: .bottom)
        .alert(LocalizedStringKey(__designTimeString("#1829_45", fallback: "email_required")), isPresented: $showAlert) {
            Button(__designTimeString("#1829_46", fallback: "OK"), role: .cancel) { }
        } message: {
            Text(LocalizedStringKey(__designTimeString("#1829_47", fallback: "email_required_message")))
        }
    }

    private func onSigninButtonTap() async {
        isButtonLoading = __designTimeBoolean("#1829_48", fallback: true)
        try? await authenticationService.signIn(
            withEmail: email,
            password: password
        )
        isButtonLoading = __designTimeBoolean("#1829_49", fallback: false)
    }
}

extension LoginScreen: AuthenticationFormProtocol {
    private func isValidEmail(_ email: String) -> Bool {
            let emailRegex = __designTimeString("#1829_50", fallback: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
            let emailPredicate = NSPredicate(format: __designTimeString("#1829_51", fallback: "SELF MATCHES %@"), emailRegex)
            return emailPredicate.evaluate(with: email)
        }

    private func isValidPassword(_ password: String) -> Bool {
            guard password.count >= __designTimeInteger("#1829_52", fallback: 6) else { return __designTimeBoolean("#1829_53", fallback: false) }

            let uppercaseRegex = __designTimeString("#1829_54", fallback: ".*[A-Z]+.*")
            let uppercasePredicate = NSPredicate(format: __designTimeString("#1829_55", fallback: "SELF MATCHES %@"), uppercaseRegex)
            guard uppercasePredicate.evaluate(with: password) else { return __designTimeBoolean("#1829_56", fallback: false) }

            let lowercaseRegex = __designTimeString("#1829_57", fallback: ".*[a-z]+.*")
            let lowercasePredicate = NSPredicate(format: __designTimeString("#1829_58", fallback: "SELF MATCHES %@"), lowercaseRegex)
            guard lowercasePredicate.evaluate(with: password) else { return __designTimeBoolean("#1829_59", fallback: false) }

            return __designTimeBoolean("#1829_60", fallback: true)
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
        opacity(shouldHide ? __designTimeInteger("#1829_61", fallback: 0) : __designTimeInteger("#1829_62", fallback: 1))
    }
}

#Preview {
    LoginScreen()
}
