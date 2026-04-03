//
//  GeminiService.swift
//  LaymanNewsApp
//
//  Created by Aditya on 01/04/26.
//

import Foundation

class GeminiService {
    
    static let shared = GeminiService()
    
    private var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String ?? ""
    }
    
    // MARK: Ask AI
    func ask(question: String, context: String) async -> String {
        
        
        
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite-preview:generateContent?key=\(apiKey)") else {
            return "Error"
        }
        
        let prompt = """
        You are Layman AI.

        Explain in very simple words.
        Answer in 1-2 short sentences.

        ONLY answer based on the article below.
        If answer is not in article, say "Not mentioned in the article."

        Article:
        \(context)

        Question:
        \(question)
        """
        
        return await sendRequest(url: url, prompt: prompt)
    }
    
    // MARK: Generate Suggestions
    func generateSuggestions(context: String) async -> [String] {
        
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite-preview:generateContent?key=\(apiKey)") else {
            return []
        }
        
        let prompt = """
        Generate 3 simple questions based on this article.
        Keep them short (max 8 words).
        
        Article: \(context)
        
        Return only questions separated by newline.
        """
        
        let result = await sendRequest(url: url, prompt: prompt)
        
        return result
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .prefix(3)
            .map { String($0) }
    }
    
    // MARK: Common Request
    private func sendRequest(url: URL, prompt: String) async -> String {
        
        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let response = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let candidates = response["candidates"] as? [[String: Any]],
               let content = candidates.first?["content"] as? [String: Any],
               let parts = content["parts"] as? [[String: Any]],
               let text = parts.first?["text"] as? String {
                
                return text
            }
            
        } catch {
            print(error)
        }
        
        return "Something went wrong."
    }
}
