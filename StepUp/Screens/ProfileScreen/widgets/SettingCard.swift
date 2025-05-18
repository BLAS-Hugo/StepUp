//
//  SettingCard.swift
//  StepUp
//
//  Created by Hugo Blas on 08/04/2025.
//

import SwiftUI

struct SettingCard: View {
    let title: LocalizedStringKey

    var body: some View {
            HStack {
                Text(title)
                    .foregroundStyle(.black)
                    .padding(.all, 16)
                Spacer()
                ZStack {
                    Image(systemName: "chevron.right")
                        .accessibilityLabel(LocalizedStringKey("navigate_to_setting"))
                        .padding(.all, 6)
                }
                .background(Color.appMediumGray.opacity(0.25))
                .clipShape(Circle())
                .padding(.horizontal, 16)
            }

        .frame(maxWidth: UIScreen.main.bounds.size.width, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 1)
        .padding(.horizontal, 16)
    }
}
