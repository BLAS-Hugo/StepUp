//
//  PasswordReAuthView.swift
//  StepUp
//
//  Created by Hugo Blas on 26/05/2025.
//

import SwiftUI

struct PasswordReAuthView: View {
    @Environment(\.dismiss) var dismiss
    @State private var password = ""
    var onSubmit: (String) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(LocalizedStringKey("enter_your_password"))
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                SecureField(LocalizedStringKey("password"), text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)

                HStack(spacing: 20) {
                    Button(LocalizedStringKey("cancel")) {
                        dismiss()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.appLightGray)
                    .foregroundColor(Color.primaryOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    Button(LocalizedStringKey("confirm")) {
                        onSubmit(password)
                        dismiss()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondaryBlue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .disabled(password.isEmpty)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 40)
            .navigationTitle(LocalizedStringKey("re-authenticate"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedStringKey("cancel")) {
                        dismiss()
                    }
                }
            }
        }
    }
}
