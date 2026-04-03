//
//  WelcomeView.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var navigateToAuth = false
    @State private var dragOffset: CGFloat = 0
    @Binding var showAuth: Bool
    
    var body: some View {
        ZStack {
            
            // MARK: - Background Gradient
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.9, blue: 0.8),
                    Color(red: 0.95, green: 0.7, blue: 0.5)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                
                Spacer().frame(height: 60)
                
                // MARK: - Logo
                Text("Layman")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.black.opacity(0.8))
                
                Spacer()
                
                // MARK: - Title Text
                VStack(spacing: 6) {
                    
                    Text("Business,")
                    Text("tech & startups")
                    
                    Text("made simple")
                        .foregroundColor(Color.orange)
                    
                }
                .font(.system(size: 28, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black.opacity(0.85))
                
                Spacer()
                
                // MARK: - Swipe Button
                swipeButton
                
            }
            .padding()
        }
    }
}


extension WelcomeView {
    
    var swipeButton: some View {
        ZStack {
            
            // Background
            Capsule()
                .fill(Color.orange)
                .frame(height: 60)
            
            // Text (centered, safe)
            Text("Swipe to get started")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 60) // prevents overlap
            
            // Slider
            HStack {
                
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 50, height: 50)
                    
                    HStack(spacing: -4) {
                        Image(systemName: "chevron.right")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.orange)
                }
                .offset(x: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width > 0 &&
                                value.translation.width < UIScreen.main.bounds.width - 120 {
                                dragOffset = value.translation.width
                            }
                        }
                        .onEnded { value in
                            
                            let threshold: CGFloat = 120
                            
                            if dragOffset > threshold {
                                
                                withAnimation(.easeOut(duration: 0.3)) {
                                    dragOffset = UIScreen.main.bounds.width - 100
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    showAuth = true
                                }
                                
                            } else {
                                withAnimation(.spring()) {
                                    dragOffset = 0
                                }
                            }
                        }
                )
                
                Spacer()
            }
            .padding(.horizontal, 6)
            
            NavigationLink(
                destination: AuthView(showAuth: $showAuth),
                isActive: $navigateToAuth
            ) {
                EmptyView()
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        
        
        
    }
}


#Preview {
    WelcomeView(showAuth: .constant(false))
}
