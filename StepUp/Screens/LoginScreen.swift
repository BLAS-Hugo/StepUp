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

    private let authService = AuthenticationService()
    @State private var isButtonLoading = false

    var body: some View {
        VStack {
            Text("Step Up")
                .font(.largeTitle)
            Text("Welcome")
            TextField("Email", text: $email, onEditingChanged: { isChanged in
                if isChanged {
                    if textFieldValidatorEmail(email) {
                        isEmailValid = true
                    } else {
                        isEmailValid = false
                    }
                }
            })
                .textFieldStyle(.plain)

            Text("Please enter a valid email adress")
                    .foregroundColor(.red)
                    //.hidden(!isEmailValid)
            SecureField("Password", text: $password)
                .textFieldStyle(.plain)

            Text("Password must be at least 8 characters long and contain one uppercase letter, one lowercase letter, and one digit")
                    .foregroundColor(.red)
                    //.hidden(!isPasswordValid)
            Button {

            } label: {
                Text("Sign up")
            }
            HStack {
                Text("Already have an account")
                Button {

                } label: {
                    Text("Log in")
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private var isFormValid: Bool {
        return !email.isEmpty && !password.isEmpty
    }

    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }

    func textFieldValidatorPassword(_ string: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
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
        opacity(shouldHide ? 0 : 1)
    }
}

#Preview {
    LoginScreen()
}
