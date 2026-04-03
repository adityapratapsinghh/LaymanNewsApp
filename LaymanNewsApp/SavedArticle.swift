//
//  SavedArticle.swift
//  LaymanNewsApp
//
//  Created by Aditya on 03/04/26.
//

import Foundation

struct SavedArticle: Identifiable, Codable {
    let id: UUID
    let user_id: UUID
    let title: String
    let description: String
    let image_url: String
    let article_url: String
    let created_at: String
}
