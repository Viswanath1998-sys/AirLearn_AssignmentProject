//
//  Airlearn_AssignmentApp.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 14/07/25.
//

import SwiftUI

@main
struct Airlearn_AssignmentApp: App {
    @AppStorage("selectedColorScheme") var selectedColorScheme = AppColorScheme.light.rawValue

    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(AppColorScheme(rawValue: selectedColorScheme)?.colorScheme)
        }
    }
}

