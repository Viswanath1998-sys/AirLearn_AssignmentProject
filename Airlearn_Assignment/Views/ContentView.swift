//
//  ContentView.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 14/07/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isNavigatetoUsersList:Bool = false
    @StateObject private var themeManager = ThemeManager()
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                
                VStack(spacing: 16){
                    Text("Welcome to Assignment").font(.headline)
                    
                    Button {
                        isNavigatetoUsersList = true
                    } label: {
                        Text("Go to GitHub Users List").padding().foregroundStyle(.white).background(RoundedRectangle(cornerRadius: 20).fill(Color.blue))
                    }
                    
                    // App Color schema Selection(Enable or Disable Dark mode)
                    Toggle(isOn: Binding<Bool>(
                        get: { themeManager.currentScheme == .dark },
                        set: { themeManager.setTheme($0 ? .dark : .light) }
                    )) {
                        Text("Dark Mode")
                            .font(.headline)
                    }
                    .toggleStyle(SwitchToggleStyle())
                    .padding(.horizontal)
                    
                    
                }
            }.preferredColorScheme(themeManager.currentScheme.colorScheme)// theme applying to Views
            .navigationDestination(isPresented: $isNavigatetoUsersList) {
                GitHubUsersListView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


