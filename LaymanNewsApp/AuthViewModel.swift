//
//  AuthViewModel.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import Foundation
import Supabase
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - SIGN UP
    func signUp() async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await SupabaseManager.shared.client.auth.signUp(
                email: email,
                password: password
            )
            
            // auto login after signup
            try await SupabaseManager.shared.client.auth.signIn(
                email: email,
                password: password
            )
            
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    // MARK: - SIGN IN
    func signIn() async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await SupabaseManager.shared.client.auth.signIn(
                email: email,
                password: password
            )
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    // MARK: - SESSION CHECK
    func checkSession() async -> Bool {
        do {
            let session = try await SupabaseManager.shared.client.auth.session
            return session.user != nil
        } catch {
            return false
        }
    }
}
