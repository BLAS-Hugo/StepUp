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
        ZStack(alignment: .bottom) {
            Color(Color.primaryOrange)
            VStack(alignment: .leading) {
                Text(__designTimeString("#6841_0", fallback: "Step up"))
                    .font(.system(size: __designTimeInteger("#6841_1", fallback: 48), weight: .bold, design: .default))
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, __designTimeInteger("#6841_2", fallback: 64))
                    .padding(.leading, __designTimeInteger("#6841_3", fallback: 32))
                VStack (spacing: __designTimeInteger("#6841_4", fallback: 10)) {
                    Text(LocalizedStringKey(__designTimeString("#6841_5", fallback: "welcome")))
                        .font(.title2)
                        .bold()
                        .offset(x: __designTimeInteger("#6841_6", fallback: -96), y: __designTimeInteger("#6841_7", fallback: -16))
                    VStack(alignment: .leading) {
                        InputView(
                            text: $email,
                            placeholder: LocalizedStringKey(__designTimeString("#6841_8", fallback: "email")),
                            errorText: LocalizedStringKey(__designTimeString("#6841_9", fallback: "email_not_valid")),
                            shouldHideErrorText: email.isEmpty || !isPasswordValid
                        )
                        InputView(
                            text: $password,
                            placeholder: LocalizedStringKey(__designTimeString("#6841_10", fallback: "password")),
                            errorText: LocalizedStringKey(__designTimeString("#6841_11", fallback: "password_not_valid")),
                            isSecureField: __designTimeBoolean("#6841_12", fallback: true),
                            shouldHideErrorText: password.isEmpty || !isPasswordValid
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
                            Text(shouldDisplaySignInPage ? LocalizedStringKey(__designTimeString("#6841_13", fallback: "signin")) : LocalizedStringKey(__designTimeString("#6841_14", fallback: "signup")))
                                .font(.system(size: __designTimeInteger("#6841_15", fallback: 20), weight: .bold, design: .rounded))
                                .padding(.vertical, __designTimeInteger("#6841_16", fallback: 12))
                                .padding(.horizontal, __designTimeInteger("#6841_17", fallback: 24))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(minWidth: __designTimeInteger("#6841_18", fallback: 135), minHeight: __designTimeInteger("#6841_19", fallback: 64))
                    .background(Color.primaryOrange)
                    .clipShape(.rect(cornerRadius: __designTimeInteger("#6841_20", fallback: 8)))
                    Button {
                        // Change view to sign in page
                        shouldDisplaySignInPage.toggle()
                    } label: {
                        Text(shouldDisplaySignInPage ? LocalizedStringKey(__designTimeString("#6841_21", fallback: "not_registered_signup")) : LocalizedStringKey(__designTimeString("#6841_22", fallback: "already_registered_signin")))
                            .font(.system(size: __designTimeInteger("#6841_23", fallback: 16), design: .rounded))
                            .underline()
                            .foregroundStyle(Color.primaryOrange)
                    }

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
                .background(Color.appLightGray)
                .clipShape(.rect(cornerRadius: __designTimeInteger("#6841_26", fallback: 24)))
            }
        }
        .ignoresSafeArea()
        .frame(alignment: .bottom)
    }

    private func onSignupButtonTap() async {
        isButtonLoading = __designTimeBoolean("#6841_27", fallback: true)
        await controller.registerUser(
            email: email,
            password: password,
            onInvalidPassword: { isPasswordValid = __designTimeBoolean("#6841_28", fallback: false) },
            onInvalidEmail: { isEmailValid = __designTimeBoolean("#6841_29", fallback: false) }
        )
        isButtonLoading = __designTimeBoolean("#6841_30", fallback: false)
    }
    private func onSigninButtonTap() {
        isButtonLoading = __designTimeBoolean("#6841_31", fallback: true)
        controller.login(
            email: email,
            password: password,
            onInvalidPassword: { isPasswordValid = __designTimeBoolean("#6841_32", fallback: false) },
            onInvalidEmail: { isEmailValid = __designTimeBoolean("#6841_33", fallback: false) }
        )
        isButtonLoading = __designTimeBoolean("#6841_34", fallback: false)
    }
}

extension View {
    func placeholder<Content: View>(
        when condition: Bool,
        @ViewBuilder placeholder: () -> Content) -> some View {

            ZStack(alignment: .leading) {
                placeholder()
                self
            }
        }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? __designTimeInteger("#6841_35", fallback: 0) : __designTimeInteger("#6841_36", fallback: 1))
    }
}

#Preview {
    LoginScreen()
}
