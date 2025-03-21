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
        _email = State(initialValue: prefilledEmail)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(Color.primaryOrange)
            VStack(alignment: .leading) {
                Text(__designTimeString("#2544_0", fallback: "Step up"))
                    .font(.system(size: __designTimeInteger("#2544_1", fallback: 48), weight: .bold, design: .default))
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, __designTimeInteger("#2544_2", fallback: 64))
                    .padding(.leading, __designTimeInteger("#2544_3", fallback: 32))
                VStack(spacing: __designTimeInteger("#2544_4", fallback: 10)) {
                    Text(LocalizedStringKey(__designTimeString("#2544_5", fallback: "signing_up")))
                        .font(.title2)
                        .bold()
                        .offset(x: __designTimeInteger("#2544_6", fallback: -96), y: __designTimeInteger("#2544_7", fallback: -16))
                    VStack(alignment: .leading) {
                        InputView(
                            text: $email,
                            placeholder: LocalizedStringKey(__designTimeString("#2544_8", fallback: "email")),
                            errorText: LocalizedStringKey(__designTimeString("#2544_9", fallback: "email_not_valid")),
                            shouldHideErrorText: isEmailValid,
                            shouldUseAutoCapitalization: __designTimeBoolean("#2544_10", fallback: false)
                        )
                        InputView(
                            text: $firstName,
                            placeholder: LocalizedStringKey(__designTimeString("#2544_11", fallback: "first_name"))
                        )
                        InputView(
                            text: $name,
                            placeholder: LocalizedStringKey(__designTimeString("#2544_12", fallback: "name"))
                        )
                        InputView(
                            text: $password,
                            placeholder: LocalizedStringKey(__designTimeString("#2544_13", fallback: "password")),
                            errorText: LocalizedStringKey(__designTimeString("#2544_14", fallback: "password_not_valid")),
                            isSecureField: __designTimeBoolean("#2544_15", fallback: true),
                            shouldHideErrorText: isPasswordValid
                        )
                        InputView(
                            text: $confirmPassword,
                            placeholder: LocalizedStringKey(__designTimeString("#2544_16", fallback: "confirm_password")),
                            errorText: LocalizedStringKey(__designTimeString("#2544_17", fallback: "password_not_equal")),
                            isSecureField: __designTimeBoolean("#2544_18", fallback: true),
                            shouldHideErrorText: isPasswordEqual,
                            shouldDisplayObscuringIcon: __designTimeBoolean("#2544_19", fallback: false)
                        )
                    }
                    Button {
                        Task {
                            isButtonLoading = __designTimeBoolean("#2544_20", fallback: true)
                            await onSignupButtonTap()
                            isButtonLoading = __designTimeBoolean("#2544_21", fallback: false)
                        }
                    } label: {
                        if isButtonLoading {
                            ProgressView()
                        } else {
                            Text(LocalizedStringKey(__designTimeString("#2544_22", fallback: "signup")))
                                .font(.system(size: __designTimeInteger("#2544_23", fallback: 20), weight: .bold, design: .rounded))
                                .padding(.vertical, __designTimeInteger("#2544_24", fallback: 12))
                                .padding(.horizontal, __designTimeInteger("#2544_25", fallback: 24))
                                .foregroundStyle(.white)
                        }
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? __designTimeInteger("#2544_26", fallback: 1) : __designTimeFloat("#2544_27", fallback: 0.5))
                    .frame(minWidth: __designTimeInteger("#2544_28", fallback: 135), minHeight: __designTimeInteger("#2544_29", fallback: 64))
                    .background(Color.primaryOrange)
                    .clipShape(.rect(cornerRadius: __designTimeInteger("#2544_30", fallback: 8)))

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
                .background(Color.appLightGray)
                .clipShape(.rect(cornerRadius: __designTimeInteger("#2544_33", fallback: 24)))
            }
        }
        .ignoresSafeArea()
        .frame(alignment: .bottom)
    }

    private func onSignupButtonTap() async {
        isButtonLoading = __designTimeBoolean("#2544_34", fallback: true)
        isPasswordEqual = password == confirmPassword

        try? await authenticationService.signUp(
            email: email,
            password: password,
            firstName: firstName,
            name: name
        )
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
