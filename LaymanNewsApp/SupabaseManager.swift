//
//  SupabaseManager.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import Foundation
import Supabase

class SupabaseManager {
    
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://drthzllhugqugoknuzkm.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRydGh6bGxodWdxdWdva251emttIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ5NjgzOTYsImV4cCI6MjA5MDU0NDM5Nn0.sRBZ6YikhEL7IHW_myzWqdfnRViNkpcQCA_Pe6EuqW0"
        )
    }
}
