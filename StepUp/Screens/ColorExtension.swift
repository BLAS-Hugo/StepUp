//
//  ColorExtension.swift
//  StepUp
//
//  Created by Hugo Blas on 14/03/2025.
//

import SwiftUI

extension Color {
    // Couleurs principales
    static let primaryOrange = Color(hex: "FF5722")
    static let secondaryBlue = Color(hex: "1E88E5")
    static let successGreen = Color(hex: "43A047")

    // Teintes neutres
    static let appWhite = Color(hex: "FFFFFF")
    static let appLightGray = Color(hex: "F5F5F5")
    static let appMediumGray = Color(hex: "9E9E9E")
    static let appDarkGray = Color(hex: "424242")
    static let appBlack = Color(hex: "212121")

    // Variantes d'orange
    static let lightOrange = Color(hex: "FF8A65")
    static let veryLightOrange = Color(hex: "FFCCBC")
    static let darkOrange = Color(hex: "E64A19")

    // Fonction pour convertir une valeur hexadécimale en Color
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3:
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}
