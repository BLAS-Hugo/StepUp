//
//  InputView.swift
//  StepUp
//
//  Created by Hugo Blas on 14/03/2025.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    var placeholder: LocalizedStringKey
    var errorText: LocalizedStringKey
    var isSecureField = false
    var shouldHideErrorText = true
    @State private var isSecured: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            if isSecureField {
                ZStack(alignment: .trailing) {
                            Group {
                                if isSecured {
                                    SecureField("", text: $text)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 8)
                                        .background(Color(.gray).opacity(0.2))
                                        .placeholder(when: text.isEmpty) {
                                            Text(placeholder)
                                                .bold()
                                                .foregroundStyle(.black.opacity(0.7))
                                                .padding(.leading, 8)
                                        }
                                        .clipShape(.rect(cornerRadius: 8))
                                } else {
                                    TextField("", text: $text)
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 8)
                                                .background(Color(.gray).opacity(0.2))
                                                .placeholder(when: text.isEmpty) {
                                                    Text(placeholder)
                                                        .bold()
                                                        .foregroundStyle(.black.opacity(0.7))
                                                        .padding(.leading, 8)
                                                }
                                                .clipShape(.rect(cornerRadius: 8))
                                }
                            }
                            Button(action: {
                                isSecured.toggle()
                            }) {
                                Image(systemName: isSecured ? "eye.slash" : "eye")
                                    .accentColor(.gray)
                            }
                            .padding(.trailing, 16)
                        }
                Text(errorText)
                    .hidden(shouldHideErrorText)
                    .foregroundStyle(.red)
            } else {
                TextField("", text: $text)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .background(Color(.gray).opacity(0.2))
                    .textInputAutocapitalization(.never)
                    .placeholder(when: text.isEmpty) {
                        Text(LocalizedStringKey("Email"))
                            .bold()
                            .foregroundStyle(.black.opacity(0.7))
                            .padding(.leading, 8)
                    }
                    .clipShape(.rect(cornerRadius: 8))
                Text(LocalizedStringKey("email_not_valid")).hidden(shouldHideErrorText)
            }
        }
        .padding(.horizontal, 24)
    }
}
