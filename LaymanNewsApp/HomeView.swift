//
//  HomeView.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                
                // MARK: Search
                
                
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: Carousel
                        carouselView
                        
                        // MARK: Today's Picks
                        HStack {
                            Text("Today's Picks")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("View All")
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            ForEach(viewModel.filteredArticles) { article in
                                NavigationLink(destination: ArticleDetailView(article: article)) {
                                    ArticleRow(article: article)
                                }
                                .padding(.horizontal)
                                .padding(.vertical)
                                
                            }
                            .background(.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchArticles()
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search articles...")
            
            .navigationTitle("Layman")
        }
        
    }
    
    
}

extension HomeView {
    
    var carouselView: some View {
        TabView {
            ForEach(viewModel.articles.prefix(5)) { article in
                
                ZStack(alignment: .bottomLeading) {
                    
                    AsyncImage(url: URL(string: article.image_url ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 200)
                    .cornerRadius(16)
                    
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .cornerRadius(16)
                    
                    Text(article.title)
                        .foregroundColor(.white)
                        .padding()
                        .lineLimit(2)
                }
                .padding(.horizontal)
            }
        }
        .frame(height: 220)
        .tabViewStyle(.page)
    }
}



#Preview {
    HomeView()
}
