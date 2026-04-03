//
//  NewsService.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import Foundation


class NewsService {
    
    static let shared = NewsService()
    
    private let apiKey = "pub_8ac630598a734482b7360b04c50b68e7"
    
    func fetchNews() async throws -> [Article] {
        
        let urlString = "https://newsdata.io/api/1/news?apikey=\(apiKey)&category=business,technology&language=en"
        
        guard let url = URL(string: urlString) else {
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
        
        return decoded.results ?? []
    }
}

struct NewsResponse: Codable {
    let results: [Article]?
}
