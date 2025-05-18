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
    var errorText: LocalizedStringKey?
    var isSecureField = false
    var shouldHideErrorText = true
    var shouldDisplayObscuringIcon = true
    var shouldUseAutoCapitalization = true

    var body: some View {
        VStack(alignment: .leading) {
            if isSecureField {
                PasswordField(
                    text: $text,
                    placeholder: placeholder,
                    shouldDisplayObscuringIcon: shouldDisplayObscuringIcon
                )
                if let errorText = errorText {
                    Text(errorText)
                        .hidden(shouldHideErrorText)
                        .foregroundStyle(.red)
                }
            } else {
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .bold()
                            .foregroundStyle(.black.opacity(0.7))
                            .padding(.leading, 8)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .background(Color(.gray).opacity(0.2))
                    .textInputAutocapitalization(shouldUseAutoCapitalization ? .words : .never)
                    .autocorrectionDisabled(true)
                    .clipShape(.rect(cornerRadius: 8))
                if let errorText = errorText {
                    Text(errorText)
                        .hidden(shouldHideErrorText)
                        .foregroundStyle(.red)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, errorText == nil ? 24 : 0)
    }
}

struct PasswordField: View {
    @Binding
    var text: String
    var placeholder: LocalizedStringKey
    var shouldDisplayObscuringIcon = true

    @State
    private var showText: Bool = false

    var body: some View {
        HStack {
            if showText {
                TextField("", text: $text)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .bold()
                            .foregroundStyle(.black.opacity(0.7))
                            .padding(.leading, 8)
                    }
            } else {
                SecureField("", text: $text)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .bold()
                            .foregroundStyle(.black.opacity(0.7))
                            .padding(.leading, 8)
                    }
            }
            if shouldDisplayObscuringIcon {
                Button {
                    showText.toggle()
                } label: {
                    Image(systemName: showText ? "eye.fill" : "eye.slash.fill")
                        .accessibilityLabel(showText
                        ? LocalizedStringKey("hide_password")
                        : LocalizedStringKey("show_password"))
                        .foregroundStyle(Color.primaryOrange)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(Color(.gray).opacity(0.2))
        .clipShape(.rect(cornerRadius: 8))
    }
}
