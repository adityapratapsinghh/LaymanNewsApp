//
//  AuthView.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import Foundation
import SwiftUI

struct AuthView: View {
    
    @StateObject var viewModel = AuthViewModel()
    @EnvironmentObject var appState: AppState
    @Binding var showAuth: Bool
    
    
    @State private var isLogin = true
    
    var body: some View {
        ZStack {
            
            // Background Gradient (same as welcome)
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.9, blue: 0.8),
                    Color(red: 0.95, green: 0.7, blue: 0.5)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Spacer()
                
                Text("Layman")
                    .font(.system(size: 32, weight: .bold))
                
                Text(isLogin ? "Welcome back" : "Create account")
                    .font(.title3)
                    .foregroundColor(.black.opacity(0.7))
                
                HStack {
                    
                    Button {
                        isLogin = true
                    } label: {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isLogin ? Color.orange : Color.clear)
                            .foregroundColor(isLogin ? .white : .black)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        isLogin = false
                    } label: {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(!isLogin ? Color.orange : Color.clear)
                            .foregroundColor(!isLogin ? .white : .black)
                            .cornerRadius(10)
                    }
                }
                .background(Color.white.opacity(0.3))
                .cornerRadius(12)
                
                // MARK: - Input Fields
                VStack(spacing: 16) {
                    
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                
                // MARK: - Error Message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // MARK: - Button
                Button {
                    Task {
                        
                        // Validation
                        if viewModel.email.isEmpty {
                            viewModel.errorMessage = "Email cannot be empty"
                            return
                        }
                        
                        if viewModel.password.count < 6 {
                            viewModel.errorMessage = "Password must be at least 6 characters"
                            return
                        }
                        
                        let success = isLogin
                        ? await viewModel.signIn()
                        : await viewModel.signUp()
                        
                        if success {
                            appState.isLoggedIn = true
                            showAuth = false
                        }
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text(isLogin ? "Login" : "Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                
                
                
                Spacer()
            }
            .padding()
        }
        
    }
}
