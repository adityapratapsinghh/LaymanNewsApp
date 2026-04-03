//
//  SavedView.swift
//  LaymanNewsApp
//
//  Created by Aditya on 03/04/26.
//


import SwiftUI

import SwiftUI

struct SavedView: View {
    
    @StateObject private var viewModel = SavedViewModel()
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                if viewModel.isLoading {
                    
                    Spacer()
                    ProgressView()
                    Spacer()
                    
                } else if viewModel.filteredArticles.isEmpty {
                    
                    Spacer()
                    Text("No saved articles yet")
                        .foregroundColor(.gray)
                    Spacer()
                    
                } else {
                    
                    List {
                        ForEach(viewModel.filteredArticles) { article in
                            
                            NavigationLink {
                                ArticleDetailView(
                                    article: article.toArticle(),
                                    isInitiallySaved: true,
                                    savedId: article.id
                                )
                            } label: {
                                
                                HStack(spacing: 12) {
                                    
                                    AsyncImage(url: URL(string: article.image_url)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color.gray.opacity(0.3)
                                    }
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(12)
                                    .clipped()
                                    
                                    Text(article.title)
                                        .font(.headline)
                                        .lineLimit(2)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let article = viewModel.filteredArticles[index]
                                Task {
                                    await viewModel.deleteArticle(id: article.id)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Saved")
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search saved articles..."
            )
            
        }
        
        .task {
            await viewModel.fetchSavedArticles()
        }
        .onReceive(NotificationCenter.default.publisher(for: .savedUpdated)) { _ in
            Task {
                await viewModel.fetchSavedArticles()
            }
        }
    }
}
extension SavedArticle {
    func toArticle() -> Article {
        return Article(
            title: self.title,
            link: self.article_url,
            image_url: self.image_url,
            description: self.description
        )
    }
}

#Preview {
    SavedView()
}
