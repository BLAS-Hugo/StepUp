import func SwiftUI.__designTimeSelection

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
        __designTimeSelection(ZStack(alignment: .bottom) {
            __designTimeSelection(Color(__designTimeSelection(Color.primaryOrange, "#1829.[2].[10].property.[0].[0].arg[1].value.[0].arg[0].value")), "#1829.[2].[10].property.[0].[0].arg[1].value.[0]")
            __designTimeSelection(VStack(alignment: .leading) {
                __designTimeSelection(Text(__designTimeString("#1829_0", fallback: "Step up"))
                    .font(__designTimeSelection(.system(size: __designTimeInteger("#1829_1", fallback: 48), weight: .bold, design: .default), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[0].modifier[0].arg[0]"))
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, __designTimeInteger("#1829_2", fallback: 64))
                    .padding(.leading, __designTimeInteger("#1829_3", fallback: 32)), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[0]")
                __designTimeSelection(VStack(spacing: __designTimeInteger("#1829_4", fallback: 10)) {
                    __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#1829_5", fallback: "welcome")), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[0].value"))
                        .font(.title2)
                        .bold()
                        .offset(x: __designTimeInteger("#1829_6", fallback: -96), y: __designTimeInteger("#1829_7", fallback: -16)), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0]")
                    __designTimeSelection(VStack(alignment: .leading) {
                        __designTimeSelection(InputView(
                            text: __designTimeSelection($email, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[0].value"),
                            placeholder: __designTimeSelection(LocalizedStringKey(__designTimeString("#1829_8", fallback: "email")), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[1].value"),
                            errorText: __designTimeSelection(LocalizedStringKey(__designTimeString("#1829_9", fallback: "email_not_valid")), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[2].value"),
                            shouldHideErrorText: __designTimeSelection(isEmailValid, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[3].value"),
                            shouldUseAutoCapitalization: __designTimeBoolean("#1829_10", fallback: false)
                        )
                        .onChange(of: __designTimeSelection(email, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].modifier[0].arg[0].value")) { oldValue, newValue in
                                        if !newValue.isEmpty {
                                            isEmailValid = isValidEmail(__designTimeSelection(newValue, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].modifier[0].arg[1].value.[0].[0].[0].[0]"))
                                        } else {
                                            isEmailValid = __designTimeBoolean("#1829_11", fallback: true)
                                        }
                                    }, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0]")
                        if shouldDisplaySignInPage {
                            __designTimeSelection(InputView(
                                text: __designTimeSelection($password, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].[0].[0].arg[0].value"),
                                placeholder: __designTimeSelection(LocalizedStringKey(__designTimeString("#1829_12", fallback: "password")), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].[0].[0].arg[1].value"),
                                errorText: __designTimeSelection(LocalizedStringKey(__designTimeString("#1829_13", fallback: "password_not_valid")), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].[0].[0].arg[2].value"),
                                isSecureField: __designTimeBoolean("#1829_14", fallback: true),
                                shouldHideErrorText: __designTimeSelection(isPasswordValid, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].[0].[0].arg[4].value")
                            ), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].[0].[0]")
                        }
                    }, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1]")

                    // Remember me button
                    if shouldDisplaySignInPage {
                    __designTimeSelection(Button {
                        __designTimeSelection(Task {
                            await __designTimeSelection(onSigninButtonTap(), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[0].[0].arg[0].value.[0].arg[0].value.[0]")
                        }, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[0].[0].arg[0].value.[0]")
                    } label: {
                        if isButtonLoading {
                            __designTimeSelection(ProgressView(), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[0].[0].arg[1].value.[0].[0].[0]")
                        } else {
                            __designTimeSelection(Text(shouldDisplaySignInPage ? LocalizedStringKey(__designTimeString("#1829_15", fallback: "signin")) : LocalizedStringKey(__designTimeString("#1829_16", fallback: "signup")))
                                .font(__designTimeSelection(.system(size: __designTimeInteger("#1829_17", fallback: 20), weight: .bold, design: .rounded), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[0].[0].arg[1].value.[0].[1].[0].modifier[0].arg[0]"))
                                .padding(.vertical, __designTimeInteger("#1829_18", fallback: 12))
                                .padding(.horizontal, __designTimeInteger("#1829_19", fallback: 24))
                                .foregroundStyle(.white), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[0].[0].arg[1].value.[0].[1].[0]")
                        }
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? __designTimeInteger("#1829_20", fallback: 1) : __designTimeFloat("#1829_21", fallback: 0.5))
                    .frame(minWidth: __designTimeInteger("#1829_22", fallback: 135), minHeight: __designTimeInteger("#1829_23", fallback: 64))
                    .background(__designTimeSelection(Color.primaryOrange, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[0].[0].modifier[3].arg[0].value"))
                    .clipShape(__designTimeSelection(.rect(cornerRadius: __designTimeInteger("#1829_24", fallback: 8)), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[0].[0].modifier[4].arg[0]")), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[0].[0]")
                    } else {
                        __designTimeSelection(Button {
                            if email.isEmpty {
                                isEmailValid = __designTimeBoolean("#1829_25", fallback: false)
                                showAlert = __designTimeBoolean("#1829_26", fallback: true)
                            } else {
                                navigateToRegister = __designTimeBoolean("#1829_27", fallback: true)
                            }
                        } label: {
                            __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#1829_28", fallback: "signup")), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[1].[0].arg[1].value.[0].arg[0].value"))
                                .font(__designTimeSelection(.system(size: __designTimeInteger("#1829_29", fallback: 20), weight: .bold, design: .rounded), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[1].[0].arg[1].value.[0].modifier[0].arg[0]"))
                                .padding(.vertical, __designTimeInteger("#1829_30", fallback: 12))
                                .padding(.horizontal, __designTimeInteger("#1829_31", fallback: 24))
                                .foregroundStyle(.white), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[1].[0].arg[1].value.[0]")
                        }
                        .frame(minWidth: __designTimeInteger("#1829_32", fallback: 135), minHeight: __designTimeInteger("#1829_33", fallback: 64))
                        .background(__designTimeSelection(Color.primaryOrange, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[1].[0].modifier[1].arg[0].value"))
                        .clipShape(__designTimeSelection(.rect(cornerRadius: __designTimeInteger("#1829_34", fallback: 8)), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[1].[0].modifier[2].arg[0]"))
                        .disabled(__designTimeSelection(email.isEmpty, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[1].[0].modifier[3].arg[0].value"))
                        .navigationDestination(isPresented: __designTimeSelection($navigateToRegister, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[1].[0].modifier[4].arg[0].value")) {
                            __designTimeSelection(RegisterScreen(prefilledEmail: __designTimeSelection(email, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[1].[0].modifier[4].arg[1].value.[0].arg[0].value"))
                                .environmentObject(__designTimeSelection(authenticationService, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[1].[0].modifier[4].arg[1].value.[0].modifier[0].arg[0].value"))
                                .navigationBarBackButtonHidden(__designTimeBoolean("#1829_35", fallback: true)), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[1].[0].modifier[4].arg[1].value.[0]")
                        }, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].[1].[0]")
                    }
                    __designTimeSelection(Button {
                        // Change view to sign in page
                        __designTimeSelection(shouldDisplaySignInPage.toggle(), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3].arg[0].value.[0]")
                        email = __designTimeString("#1829_36", fallback: "")
                        password = __designTimeString("#1829_37", fallback: "")
                    } label: {
                        __designTimeSelection(Text(shouldDisplaySignInPage
                        ? LocalizedStringKey(__designTimeString("#1829_38", fallback: "not_registered_signup"))
                        : LocalizedStringKey(__designTimeString("#1829_39", fallback: "already_registered_signin")))
                            .font(__designTimeSelection(.system(size: __designTimeInteger("#1829_40", fallback: 16), design: .rounded), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3].arg[1].value.[0].modifier[0].arg[0]"))
                            .underline()
                            .foregroundStyle(__designTimeSelection(Color.primaryOrange, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3].arg[1].value.[0].modifier[2].arg[0].value")), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3].arg[1].value.[0]")
                    }, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3]")

                    // Other connection methods
                    // Google
                }
                .ignoresSafeArea()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: UIScreen.main.bounds.size.height * __designTimeFloat("#1829_41", fallback: 0.6),
                    alignment: .top
                )
                .padding(.top, __designTimeInteger("#1829_42", fallback: 64))
                .background(__designTimeSelection(Color.appLightGray, "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].modifier[3].arg[0].value"))
                .clipShape(__designTimeSelection(.rect(cornerRadius: __designTimeInteger("#1829_43", fallback: 24)), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1].modifier[4].arg[0]")), "#1829.[2].[10].property.[0].[0].arg[1].value.[1].arg[1].value.[1]")
            }, "#1829.[2].[10].property.[0].[0].arg[1].value.[1]")
        }
        .ignoresSafeArea()
        .frame(alignment: .bottom)
        .alert(__designTimeSelection(LocalizedStringKey(__designTimeString("#1829_44", fallback: "email_required")), "#1829.[2].[10].property.[0].[0].modifier[2].arg[0].value"), isPresented: __designTimeSelection($showAlert, "#1829.[2].[10].property.[0].[0].modifier[2].arg[1].value")) {
            __designTimeSelection(Button(__designTimeString("#1829_45", fallback: "OK"), role: .cancel) { }, "#1829.[2].[10].property.[0].[0].modifier[2].arg[2].value.[0]")
        } message: {
            __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#1829_46", fallback: "email_required_message")), "#1829.[2].[10].property.[0].[0].modifier[2].arg[3].value.[0].arg[0].value")), "#1829.[2].[10].property.[0].[0].modifier[2].arg[3].value.[0]")
        }, "#1829.[2].[10].property.[0].[0]")
    }

    private func isValidEmail(_ email: String) -> Bool {
            let emailRegex = __designTimeString("#1829_47", fallback: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
            let emailPredicate = NSPredicate(format: __designTimeString("#1829_48", fallback: "SELF MATCHES %@"), __designTimeSelection(emailRegex, "#1829.[2].[11].[1].value.arg[1].value"))
            return __designTimeSelection(emailPredicate.evaluate(with: __designTimeSelection(email, "#1829.[2].[11].[2].modifier[0].arg[0].value")), "#1829.[2].[11].[2]")
        }

    private func onSigninButtonTap() async {
        isButtonLoading = __designTimeBoolean("#1829_49", fallback: true)
        try? await __designTimeSelection(authenticationService.signIn(
            withEmail: __designTimeSelection(email, "#1829.[2].[12].[1].[0]"),
            password: __designTimeSelection(password, "#1829.[2].[12].[1].[0]")
        ), "#1829.[2].[12].[1].[0]")
        isButtonLoading = __designTimeBoolean("#1829_50", fallback: false)
    }
}

extension LoginScreen: AuthenticationFormProtocol {
    var isFormValid: Bool {
        return !email.isEmpty
        && email.contains(__designTimeString("#1829_51", fallback: "@"))
        && !password.isEmpty
        && password.count >= __designTimeInteger("#1829_52", fallback: 6)
    }
}

extension View {
    func placeholder<Content: View>(
        when condition: Bool,
        @ViewBuilder placeholder: () -> Content) -> some View {

            __designTimeSelection(ZStack(alignment: .leading) {
                if condition {
                    __designTimeSelection(placeholder(), "#1829.[4].[0].[0].arg[1].value.[0].[0].[0]")
                }
                __designTimeSelection(self, "#1829.[4].[0].[0].arg[1].value.[1]")
            }, "#1829.[4].[0].[0]")
        }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        __designTimeSelection(opacity(shouldHide ? __designTimeInteger("#1829_53", fallback: 0) : __designTimeInteger("#1829_54", fallback: 1)), "#1829.[5].[0].[0]")
    }
}

#Preview {
    LoginScreen()
}
