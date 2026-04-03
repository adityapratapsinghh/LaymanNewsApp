//
//  ChatView.swift
//  LaymanNewsApp
//
//  Created by Aditya on 01/04/26.
//

import SwiftUI

struct ChatView: View {
    
    let article: Article
    
    @State private var message = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hi, I’m Layman!\nWhat can I answer for you?", isUser: false)
    ]
    @State private var suggestions: [String] = []
    @State private var isLoading = false
    @State private var isLoadingSuggestions = true
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        ForEach(messages) { msg in
                            messageRow(msg)
                        }
                        
                        if messages.count == 1 {
                            
                            if isLoadingSuggestions {
                                Text("Generating questions...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            } else {
                                VStack(alignment: .leading, spacing: 12) {
                                    
                                    Text("Question Suggestions:")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    ForEach(suggestions, id: \.self) { suggestion in
                                        Button {
                                            sendSuggestion(suggestion)
                                        } label: {
                                            Text(suggestion)
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 12)
                                                .background(Color.orange)
                                                .foregroundColor(.white)
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if isLoading {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.orange)
                                
                                Text("Typing...")
                                    .padding()
                                    .background(Color.orange.opacity(0.2))
                                    .cornerRadius(12)
                            }
                            Spacer()
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
            }
            
            HStack {
                TextField("Type your question...", text: $message)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .navigationTitle("Ask Layman")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                let result = await GeminiService.shared.generateSuggestions(
                    context: article.title + " " + (article.description ?? "")
                )
                
                await MainActor.run {
                    self.suggestions = result
                    self.isLoadingSuggestions = false
                }
            }
        }
    }
}


extension ChatView {
    
    func messageRow(_ msg: ChatMessage) -> some View {
        HStack {
            
            if msg.isUser {
                Spacer()
                Text(msg.text)
                    .padding()
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(12)
            } else {
                HStack(alignment: .top) {
                    Image(systemName: "sparkles")
                        .foregroundColor(.orange)
                    
                    Text(msg.text)
                        .padding()
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(12)
                }
                Spacer()
            }
        }
    }
    
    func sendMessage() {
        guard !message.isEmpty else { return }
        
        let userMsg = ChatMessage(text: message, isUser: true)
        messages.append(userMsg)
        
        let current = message
        message = ""
        
        isLoading = true   // ✅ START LOADING
        
        Task {
            let response = await GeminiService.shared.ask(
                question: current,
                context: article.title + " " + (article.description ?? "")
            )
            
            let botMsg = ChatMessage(text: response, isUser: false)
            
            await MainActor.run {
                isLoading = false   // ✅ STOP LOADING
                messages.append(botMsg)
            }
        }
    }
    
    func sendSuggestion(_ text: String) {
        message = text
        sendMessage()
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}


//#Preview {
//    ChatView()
//}
