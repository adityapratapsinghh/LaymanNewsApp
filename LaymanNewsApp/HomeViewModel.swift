//
//  HomeViewModel.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var searchText = ""
    
    var filteredArticles: [Article] {
        if searchText.isEmpty {
            return articles
        } else {
            return articles.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func fetchArticles() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            articles = try await NewsService.shared.fetchNews()
        } catch {
            print("Error fetching news:", error)
        }
    }
}
