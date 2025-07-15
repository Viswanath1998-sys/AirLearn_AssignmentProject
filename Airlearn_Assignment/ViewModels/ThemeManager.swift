//
//  ThemeManager.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 15/07/25.
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("selectedColorScheme") var selectedColorScheme: String = AppColorScheme.light.rawValue

    var currentScheme: AppColorScheme {
        AppColorScheme(rawValue: selectedColorScheme) ?? .light
    }

    func setTheme(_ theme: AppColorScheme) {
        selectedColorScheme = theme.rawValue
    }
}


enum AppColorScheme: String, CaseIterable, Identifiable {
    case light, dark

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
}
