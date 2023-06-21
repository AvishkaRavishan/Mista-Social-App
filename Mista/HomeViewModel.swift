//
//  HomeViewModel.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-20.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchPosts() {
        FirestoreService().fetchPosts { result in
            switch result {
            case .success(let posts):
                self.posts = posts
            case .failure(let error):
                print("Fetch error:", error.localizedDescription)
            }
        }
    }
}
