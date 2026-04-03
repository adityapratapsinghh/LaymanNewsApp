//
//  ProfileView.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import SwiftUI


struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 20) {
                
                Spacer()
                
                // MARK: Profile Icon
                Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                    )
                
                // MARK: Email
                Text(viewModel.email)
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.8))
                
                Spacer()
                
                // MARK: Logout Button
                Button {
                    Task {
                        await viewModel.signOut()
                        
                        appState.isLoggedIn = false
                    }
                }
                 label: {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Profile")
            .onAppear {
                Task {
                    await viewModel.fetchUser()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
