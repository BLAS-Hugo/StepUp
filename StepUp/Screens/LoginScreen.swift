//
//  LoginScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 04/03/2025.
//

import SwiftUI

struct LoginScreen: View {

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            Text("Welcome")
            TextField("Email", text: $email)
                .textFieldStyle(.plain)
            SecureField("Password", text: $password)
                .textFieldStyle(.plain)
            Button {
                if isFormValid {
                    print("Can sign up")
                }
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
    }

    private var isFormValid: Bool {
        return !email.isEmpty && !password.isEmpty
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

#Preview {
    LoginScreen()
}
