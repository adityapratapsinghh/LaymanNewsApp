//
//  RootView.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import SwiftUI

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var appState: AppState
    @State private var showAuth = false
    @State private var isCheckingSession = true   // 🔥 NEW
    
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            
            if isCheckingSession {
                ProgressView()
                
            } else if appState.isLoggedIn {
                MainTabView()
                    .transition(.opacity)
                
            } else if showAuth {
                AuthView(showAuth: $showAuth)
                    .transition(.move(edge: .trailing))
                
            } else {
                WelcomeView(showAuth: $showAuth)
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: showAuth)
        
        // 🔥 IMPORTANT: CHECK SESSION ON APP START
        .task {
            let isLoggedIn = await viewModel.checkSession()
            appState.isLoggedIn = isLoggedIn
            isCheckingSession = false
        }
    }
}
