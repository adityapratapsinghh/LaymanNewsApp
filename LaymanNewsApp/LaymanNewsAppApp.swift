//
//  LaymanNewsAppApp.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import SwiftUI

@main
struct LaymanNewsAppApp: App {
    
    @StateObject var appState = AppState()
    
    init() {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            
            // 🔥 glass effect
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor.clear
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}





