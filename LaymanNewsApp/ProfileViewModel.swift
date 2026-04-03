//
//  ProfileViewModel.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import Foundation
import Supabase
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var isLoading = false
    
    func fetchUser() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let user = try await SupabaseManager.shared.client.auth.session.user
            email = user.email ?? "No Email"
        } catch {
            print("Error fetching user:", error)
        }
    }
    
    func signOut() async {
        do {
            try await SupabaseManager.shared.client.auth.signOut()
        } catch {
            print("Error signing out:", error)
        }
    }
}
