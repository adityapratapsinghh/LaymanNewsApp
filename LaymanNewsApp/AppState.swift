//
//  AppState.swift
//  LaymanNewsApp
//
//  Created by Aditya on 31/03/26.
//

import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}


