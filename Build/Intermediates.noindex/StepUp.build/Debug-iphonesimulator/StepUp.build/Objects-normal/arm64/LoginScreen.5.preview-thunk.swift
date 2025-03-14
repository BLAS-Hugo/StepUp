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
        __designTimeSelection(ZStack(alignment: .bottom) {
            __designTimeSelection(Color(__designTimeSelection(Color.primaryOrange, "#6841.[1].[8].property.[0].[0].arg[1].value.[0].arg[0].value")), "#6841.[1].[8].property.[0].[0].arg[1].value.[0]")
            __designTimeSelection(VStack(alignment: .leading) {
                __designTimeSelection(Text(__designTimeString("#6841_0", fallback: "Step up"))
                    .font(__designTimeSelection(.system(size: __designTimeInteger("#6841_1", fallback: 48), weight: .bold, design: .default), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[0].modifier[0].arg[0]"))
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, __designTimeInteger("#6841_2", fallback: 64))
                    .padding(.leading, __designTimeInteger("#6841_3", fallback: 32)), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[0]")
                __designTimeSelection(VStack (spacing: __designTimeInteger("#6841_4", fallback: 10)) {
                    __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#6841_5", fallback: "welcome")), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[0].value"))
                        .font(.title2)
                        .bold()
                        .offset(x: __designTimeInteger("#6841_6", fallback: -96), y: __designTimeInteger("#6841_7", fallback: -16)), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0]")
                    __designTimeSelection(VStack(alignment: .leading) {
                        __designTimeSelection(InputView(
                            text: __designTimeSelection($email, "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[0].value"),
                            placeholder: __designTimeSelection(LocalizedStringKey(__designTimeString("#6841_8", fallback: "email")), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[1].value"),
                            errorText: __designTimeSelection(LocalizedStringKey(__designTimeString("#6841_9", fallback: "email_not_valid")), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[2].value"),
                            shouldHideErrorText: email.isEmpty || !isPasswordValid
                        ), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0]")
                        __designTimeSelection(InputView(
                            text: __designTimeSelection($password, "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[0].value"),
                            placeholder: __designTimeSelection(LocalizedStringKey(__designTimeString("#6841_10", fallback: "password")), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value"),
                            errorText: __designTimeSelection(LocalizedStringKey(__designTimeString("#6841_11", fallback: "password_not_valid")), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[2].value"),
                            isSecureField: __designTimeBoolean("#6841_12", fallback: true),
                            shouldHideErrorText: password.isEmpty || !isPasswordValid
                        ), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1]")
                    }, "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1]")


                    // Remember me button


                    __designTimeSelection(Button {
                        // Call sign up function
                        if shouldDisplaySignInPage {
                            __designTimeSelection(onSigninButtonTap(), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[0].value.[0].[0].[0]")
                        } else {
                            __designTimeSelection(Task {
                                await __designTimeSelection(onSignupButtonTap(), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[0].value.[0].[1].[0].arg[0].value.[0]")
                            }, "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[0].value.[0].[1].[0]")
                        }
                    } label: {
                        if isButtonLoading {
                            __designTimeSelection(ProgressView(), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[1].value.[0].[0].[0]")
                        } else {
                            __designTimeSelection(Text(shouldDisplaySignInPage ? LocalizedStringKey(__designTimeString("#6841_13", fallback: "signin")) : LocalizedStringKey(__designTimeString("#6841_14", fallback: "signup")))
                                .font(__designTimeSelection(.system(size: __designTimeInteger("#6841_15", fallback: 20), weight: .bold, design: .rounded), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[1].value.[0].[1].[0].modifier[0].arg[0]"))
                                .padding(.vertical, __designTimeInteger("#6841_16", fallback: 12))
                                .padding(.horizontal, __designTimeInteger("#6841_17", fallback: 24))
                                .foregroundStyle(.white), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[1].value.[0].[1].[0]")
                        }
                    }
                    .frame(minWidth: __designTimeInteger("#6841_18", fallback: 135), minHeight: __designTimeInteger("#6841_19", fallback: 64))
                    .background(__designTimeSelection(Color.primaryOrange, "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].modifier[1].arg[0].value"))
                    .clipShape(__designTimeSelection(.rect(cornerRadius: __designTimeInteger("#6841_20", fallback: 8)), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].modifier[2].arg[0]")), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2]")
                    __designTimeSelection(Button {
                        // Change view to sign in page
                        __designTimeSelection(shouldDisplaySignInPage.toggle(), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3].arg[0].value.[0]")
                    } label: {
                        __designTimeSelection(Text(shouldDisplaySignInPage ? LocalizedStringKey(__designTimeString("#6841_21", fallback: "not_registered_signup")) : LocalizedStringKey(__designTimeString("#6841_22", fallback: "already_registered_signin")))
                            .font(__designTimeSelection(.system(size: __designTimeInteger("#6841_23", fallback: 16), design: .rounded), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3].arg[1].value.[0].modifier[0].arg[0]"))
                            .underline()
                            .foregroundStyle(__designTimeSelection(Color.primaryOrange, "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3].arg[1].value.[0].modifier[2].arg[0].value")), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3].arg[1].value.[0]")
                    }, "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3]")

                    // Other connection methods
                    // Google
                }
                .ignoresSafeArea()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: UIScreen.main.bounds.size.height * __designTimeFloat("#6841_24", fallback: 0.6),
                    alignment: .top
                )
                .padding(.top, __designTimeInteger("#6841_25", fallback: 64))
                .background(__designTimeSelection(Color.appLightGray, "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].modifier[3].arg[0].value"))
                .clipShape(__designTimeSelection(.rect(cornerRadius: __designTimeInteger("#6841_26", fallback: 24)), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1].modifier[4].arg[0]")), "#6841.[1].[8].property.[0].[0].arg[1].value.[1].arg[1].value.[1]")
            }, "#6841.[1].[8].property.[0].[0].arg[1].value.[1]")
        }
        .ignoresSafeArea()
        .frame(alignment: .bottom), "#6841.[1].[8].property.[0].[0]")
    }

    private func onSignupButtonTap() async {
        isButtonLoading = __designTimeBoolean("#6841_27", fallback: true)
        await __designTimeSelection(controller.registerUser(
            email: __designTimeSelection(email, "#6841.[1].[9].[1].modifier[0].arg[0].value"),
            password: __designTimeSelection(password, "#6841.[1].[9].[1].modifier[0].arg[1].value"),
            onInvalidPassword: { isPasswordValid = __designTimeBoolean("#6841_28", fallback: false) },
            onInvalidEmail: { isEmailValid = __designTimeBoolean("#6841_29", fallback: false) }
        ), "#6841.[1].[9].[1]")
        isButtonLoading = __designTimeBoolean("#6841_30", fallback: false)
    }
    private func onSigninButtonTap() {
        isButtonLoading = __designTimeBoolean("#6841_31", fallback: true)
        __designTimeSelection(controller.login(
            email: __designTimeSelection(email, "#6841.[1].[10].[1].modifier[0].arg[0].value"),
            password: __designTimeSelection(password, "#6841.[1].[10].[1].modifier[0].arg[1].value"),
            onInvalidPassword: { isPasswordValid = __designTimeBoolean("#6841_32", fallback: false) },
            onInvalidEmail: { isEmailValid = __designTimeBoolean("#6841_33", fallback: false) }
        ), "#6841.[1].[10].[1]")
        isButtonLoading = __designTimeBoolean("#6841_34", fallback: false)
    }
}

extension View {
    func placeholder<Content: View>(
        when condition: Bool,
        @ViewBuilder placeholder: () -> Content) -> some View {

            __designTimeSelection(ZStack(alignment: .leading) {
                __designTimeSelection(placeholder(), "#6841.[2].[0].[0].arg[1].value.[0]")
                __designTimeSelection(self, "#6841.[2].[0].[0].arg[1].value.[1]")
            }, "#6841.[2].[0].[0]")
        }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        __designTimeSelection(opacity(shouldHide ? __designTimeInteger("#6841_35", fallback: 0) : __designTimeInteger("#6841_36", fallback: 1)), "#6841.[3].[0].[0]")
    }
}

#Preview {
    LoginScreen()
}
