//
//  SavedViewModel.swift
//  LaymanNewsApp
//
//  Created by Aditya on 03/04/26.
//


import Foundation
import Supabase
import SwiftUI
import Combine

@MainActor
class SavedViewModel: ObservableObject {
    
    @Published var savedArticles: [SavedArticle] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let supabase = SupabaseManager.shared.client
    
    // MARK: - Fetch Saved Articles
    func fetchSavedArticles() async {
        isLoading = true
        
        do {
            let response = try await supabase
                .from("saved_articles")
                .select()
                .order("created_at", ascending: false)
                .execute()
            
            let data = response.data
            
            let decoded = try JSONDecoder().decode([SavedArticle].self, from: data)
            
            self.savedArticles = decoded
            
        } catch {
            print("❌ Fetch Saved Error:", error)
        }
        
        isLoading = false
    }
    
    // MARK: - Delete Article
    func deleteArticle(id: UUID) async {
        do {
            try await supabase
                .from("saved_articles")
                .delete()
                .eq("id", value: id)
                .execute()
            
            // Update UI instantly
            savedArticles.removeAll { $0.id == id }
            
        } catch {
            print("❌ Delete Error:", error)
        }
    }
    
    // MARK: - Filtered Articles
    var filteredArticles: [SavedArticle] {
        if searchText.isEmpty {
            return savedArticles
        } else {
            return savedArticles.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
