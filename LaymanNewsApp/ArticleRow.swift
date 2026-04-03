//
//  ArticleRow.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import Foundation
import SwiftUI

struct ArticleRow: View {
    
    let article: Article
    
    var body: some View {
        HStack(spacing: 12) {
            
            AsyncImage(url: URL(string: article.image_url ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 80, height: 80)
            .cornerRadius(10)
            
            Text(article.title)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(3)
                .foregroundColor(.primary)
            
            
            
            Spacer()
        }
    }
}
