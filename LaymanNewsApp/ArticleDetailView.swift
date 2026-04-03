//
//  ArticleDetailView.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//


import SwiftUI
import SafariServices
import Supabase

struct ArticleDetailView: View {
    
    let article: Article
    
    @State private var showSafari = false
    @State private var currentIndex = 0
    @State private var showShare = false
    @State private var showChat = false
    
    // MARK: - Save State
    @State private var isSaved: Bool
    @State private var savedId: UUID?
    
    
    init(article: Article, isInitiallySaved: Bool = false, savedId: UUID? = nil) {
        self.article = article
        _isSaved = State(initialValue: isInitiallySaved)
        _savedId = State(initialValue: savedId)
    }
    
    
    private let supabase = SupabaseManager.shared.client
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: Title
                    Text(article.title)
                        .font(.title2)
                        .bold()
                        .lineLimit(2)
                    
                    // MARK: Image
                    AsyncImage(url: URL(string: article.image_url ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 220)
                    .cornerRadius(16)
                    .clipped()
                    
                    // MARK: Swipe Cards
                    contentCards
                }
                .padding()
            }
            
            // MARK: Ask Layman Button
            Button {
                showChat = true
            } label: {
                Text("Ask Layman")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding()
            }
            .sheet(isPresented: $showChat) {
                NavigationStack {
                    ChatView(article: article)
                }
            }
        }
        .task {
            await checkIfSaved()
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: URL(string: article.link)!)
        }
        .sheet(isPresented: $showShare) {
            ShareSheet(url: URL(string: article.link)!)
        }
        .toolbar {
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                // Open Link
                Button {
                    showSafari = true
                } label: {
                    Image(systemName: "link")
                }
                
                // MARK: Bookmark Button
                Button {
                    Task {
                        await toggleSave()
                    }
                } label: {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                }
                
                // Share
                Button {
                    showShare = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Supabase Logic

extension ArticleDetailView {
    
    // ✅ Check if already saved
    func checkIfSaved() async {
        guard let user = supabase.auth.currentUser else { return }
        
        do {
            let response = try await supabase
                .from("saved_articles")
                .select()
                .eq("user_id", value: user.id)
                .eq("article_url", value: article.link)
                .execute()
            
            let decoded = try JSONDecoder().decode([SavedArticle].self, from: response.data)
            
            if let first = decoded.first {
                isSaved = true
                savedId = first.id
            }
            
        } catch {
            print("❌ Check Save Error:", error)
        }
    }
    
    // ✅ Toggle Save / Unsave
    func toggleSave() async {
        guard let user = supabase.auth.currentUser else { return }
        
        do {
            if isSaved {
                // DELETE
               
                if let id = savedId {
                    try await supabase
                        .from("saved_articles")
                        .delete()
                        .eq("id", value: id)
                        .execute()
                    
                    withAnimation {
                        isSaved = false
                    }
                    
                    savedId = nil
                    
                    NotificationCenter.default.post(name: .savedUpdated, object: nil)
                }
                
            } else {
                // INSERT
                
                let data = SavedArticleInsert(
                    user_id: user.id,
                    title: article.title,
                    description: article.description ?? "",
                    image_url: article.image_url ?? "",
                    article_url: article.link
                )

                let response = try await supabase
                    .from("saved_articles")
                    .insert(data)
                    .select()
                    .single()
                    .execute()
                
                let saved = try JSONDecoder().decode(SavedArticle.self, from: response.data)
                
                withAnimation {
                    isSaved = true
                }
                
                savedId = saved.id
                NotificationCenter.default.post(name: .savedUpdated, object: nil)

            }
            
        } catch {
            print("❌ Toggle Save Error:", error)
        }
    }
}

// MARK: - Content Cards

extension ArticleDetailView {
    
    var contentCards: some View {
        TabView(selection: $currentIndex) {
            
            ForEach(0..<3, id: \.self) { index in
                Text(generateDummyContent(index: index))
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 140)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(16)
                    .lineLimit(6)
                    .tag(index)
            }
        }
        .frame(height: 160)
        .tabViewStyle(.page)
    }
}

// MARK: - Dummy Content

func generateDummyContent(index: Int) -> String {
    return "This is a simple explanation of the article written in easy language so anyone can understand what is happening without any technical background or confusion in reading the content clearly."
}


struct SavedArticleInsert: Encodable {
    let user_id: UUID
    let title: String
    let description: String
    let image_url: String
    let article_url: String
}


extension Notification.Name {
    static let savedUpdated = Notification.Name("savedUpdated")
}
