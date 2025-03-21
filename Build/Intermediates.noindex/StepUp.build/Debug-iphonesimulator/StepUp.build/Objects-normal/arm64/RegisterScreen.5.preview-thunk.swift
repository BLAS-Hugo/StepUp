import func SwiftUI.__designTimeSelection

import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Volumes/SSD Mac/Dev/Open Classroom/projet libre/StepUp/StepUp/Screens/LoginScreen/RegisterScreen.swift", line: 1)
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

    @EnvironmentObject var authenticationService: AuthenticationService

    init(prefilledEmail: String = "") {
        _email = State(initialValue: __designTimeSelection(prefilledEmail, "#2544.[1].[10].[0].[0]"))
    }

    var body: some View {
        __designTimeSelection(ZStack(alignment: .bottom) {
            __designTimeSelection(Color(__designTimeSelection(Color.primaryOrange, "#2544.[1].[11].property.[0].[0].arg[1].value.[0].arg[0].value")), "#2544.[1].[11].property.[0].[0].arg[1].value.[0]")
            __designTimeSelection(VStack(alignment: .leading) {
                __designTimeSelection(Text(__designTimeString("#2544_0", fallback: "Step up"))
                    .font(__designTimeSelection(.system(size: __designTimeInteger("#2544_1", fallback: 48), weight: .bold, design: .default), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[0].modifier[0].arg[0]"))
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, __designTimeInteger("#2544_2", fallback: 64))
                    .padding(.leading, __designTimeInteger("#2544_3", fallback: 32)), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[0]")
                __designTimeSelection(VStack(spacing: __designTimeInteger("#2544_4", fallback: 10)) {
                    __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#2544_5", fallback: "signing_up")), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[0].value"))
                        .font(.title2)
                        .bold()
                        .offset(x: __designTimeInteger("#2544_6", fallback: -96), y: __designTimeInteger("#2544_7", fallback: -16)), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0]")
                    __designTimeSelection(VStack(alignment: .leading) {
                        __designTimeSelection(InputView(
                            text: __designTimeSelection($email, "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[0].value"),
                            placeholder: __designTimeSelection(LocalizedStringKey(__designTimeString("#2544_8", fallback: "email")), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[1].value"),
                            errorText: __designTimeSelection(LocalizedStringKey(__designTimeString("#2544_9", fallback: "email_not_valid")), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[2].value"),
                            shouldHideErrorText: __designTimeSelection(isEmailValid, "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0].arg[3].value"),
                            shouldUseAutoCapitalization: __designTimeBoolean("#2544_10", fallback: false)
                        ), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[0]")
                        __designTimeSelection(InputView(
                            text: __designTimeSelection($firstName, "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[0].value"),
                            placeholder: __designTimeSelection(LocalizedStringKey(__designTimeString("#2544_11", fallback: "first_name")), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value")
                        ), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1]")
                        __designTimeSelection(InputView(
                            text: __designTimeSelection($name, "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[0].value"),
                            placeholder: __designTimeSelection(LocalizedStringKey(__designTimeString("#2544_12", fallback: "name")), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[1].value")
                        ), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2]")
                        __designTimeSelection(InputView(
                            text: __designTimeSelection($password, "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3].arg[0].value"),
                            placeholder: __designTimeSelection(LocalizedStringKey(__designTimeString("#2544_13", fallback: "password")), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3].arg[1].value"),
                            errorText: __designTimeSelection(LocalizedStringKey(__designTimeString("#2544_14", fallback: "password_not_valid")), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3].arg[2].value"),
                            isSecureField: __designTimeBoolean("#2544_15", fallback: true),
                            shouldHideErrorText: __designTimeSelection(isPasswordValid, "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3].arg[4].value")
                        ), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[3]")
                        __designTimeSelection(InputView(
                            text: __designTimeSelection($confirmPassword, "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[4].arg[0].value"),
                            placeholder: __designTimeSelection(LocalizedStringKey(__designTimeString("#2544_16", fallback: "confirm_password")), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[4].arg[1].value"),
                            errorText: __designTimeSelection(LocalizedStringKey(__designTimeString("#2544_17", fallback: "password_not_equal")), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[4].arg[2].value"),
                            isSecureField: __designTimeBoolean("#2544_18", fallback: true),
                            shouldHideErrorText: __designTimeSelection(isPasswordEqual, "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[4].arg[4].value"),
                            shouldDisplayObscuringIcon: __designTimeBoolean("#2544_19", fallback: false)
                        ), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1].arg[1].value.[4]")
                    }, "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[1]")
                    __designTimeSelection(Button {
                        __designTimeSelection(Task {
                            isButtonLoading = __designTimeBoolean("#2544_20", fallback: true)
                            await __designTimeSelection(onSignupButtonTap(), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[0].value.[0].arg[0].value.[1]")
                            isButtonLoading = __designTimeBoolean("#2544_21", fallback: false)
                        }, "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[0].value.[0]")
                    } label: {
                        if isButtonLoading {
                            __designTimeSelection(ProgressView(), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[1].value.[0].[0].[0]")
                        } else {
                            __designTimeSelection(Text(__designTimeSelection(LocalizedStringKey(__designTimeString("#2544_22", fallback: "signup")), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[1].value.[0].[1].[0].arg[0].value"))
                                .font(__designTimeSelection(.system(size: __designTimeInteger("#2544_23", fallback: 20), weight: .bold, design: .rounded), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[1].value.[0].[1].[0].modifier[0].arg[0]"))
                                .padding(.vertical, __designTimeInteger("#2544_24", fallback: 12))
                                .padding(.horizontal, __designTimeInteger("#2544_25", fallback: 24))
                                .foregroundStyle(.white), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].arg[1].value.[0].[1].[0]")
                        }
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? __designTimeInteger("#2544_26", fallback: 1) : __designTimeFloat("#2544_27", fallback: 0.5))
                    .frame(minWidth: __designTimeInteger("#2544_28", fallback: 135), minHeight: __designTimeInteger("#2544_29", fallback: 64))
                    .background(__designTimeSelection(Color.primaryOrange, "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].modifier[3].arg[0].value"))
                    .clipShape(__designTimeSelection(.rect(cornerRadius: __designTimeInteger("#2544_30", fallback: 8)), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2].modifier[4].arg[0]")), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].arg[1].value.[2]")

                    // Other connection methods
                    // Google
                }
                .ignoresSafeArea()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: UIScreen.main.bounds.size.height * __designTimeFloat("#2544_31", fallback: 0.65),
                    alignment: .top
                )
                .padding(.top, __designTimeInteger("#2544_32", fallback: 64))
                .background(__designTimeSelection(Color.appLightGray, "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].modifier[3].arg[0].value"))
                .clipShape(__designTimeSelection(.rect(cornerRadius: __designTimeInteger("#2544_33", fallback: 24)), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1].modifier[4].arg[0]")), "#2544.[1].[11].property.[0].[0].arg[1].value.[1].arg[1].value.[1]")
            }, "#2544.[1].[11].property.[0].[0].arg[1].value.[1]")
        }
        .ignoresSafeArea()
        .frame(alignment: .bottom), "#2544.[1].[11].property.[0].[0]")
    }

    private func onSignupButtonTap() async {
        isButtonLoading = __designTimeBoolean("#2544_34", fallback: true)
        isPasswordEqual = password == confirmPassword

        try? await __designTimeSelection(authenticationService.signUp(
            email: __designTimeSelection(email, "#2544.[1].[12].[2].[0]"),
            password: __designTimeSelection(password, "#2544.[1].[12].[2].[0]"),
            firstName: __designTimeSelection(firstName, "#2544.[1].[12].[2].[0]"),
            name: __designTimeSelection(name, "#2544.[1].[12].[2].[0]")
        ), "#2544.[1].[12].[2].[0]")
        isButtonLoading = __designTimeBoolean("#2544_35", fallback: false)
    }
}

extension RegisterScreen: AuthenticationFormProtocol {
    var isFormValid: Bool {
        return !email.isEmpty
        && email.contains(__designTimeString("#2544_36", fallback: "@"))
        && !firstName.isEmpty
        && !name.isEmpty
        && !password.isEmpty
        && password.count >= __designTimeInteger("#2544_37", fallback: 6)
        && !confirmPassword.isEmpty
        && confirmPassword.count >= __designTimeInteger("#2544_38", fallback: 6)
        && password == confirmPassword
    }
}

#Preview {
    RegisterScreen()
}
