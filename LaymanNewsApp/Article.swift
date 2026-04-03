//
//  Article.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import Foundation

struct Article: Identifiable, Codable {
    let id = UUID()
    
    let title: String
    let link: String
    let image_url: String?
    let description: String?
}
