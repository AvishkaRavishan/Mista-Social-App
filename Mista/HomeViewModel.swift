//
//  HomeViewModel.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private let firestore = Firestore.firestore()

    // Fetch all posts
    func fetchPosts() {
        firestore.collection("posts")
            .order(by: "timestamp", descending: true) // Fetch posts in descending order of timestamp
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Failed to fetch posts: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    self?.posts = []
                    return
                }

                let posts = documents.compactMap { document -> Post? in
                    guard let data = document.data() as? [String: Any],
                          let imageURL = data["imageURL"] as? String,
                          let text = data["text"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    return Post(id: document.documentID, imageURL: imageURL, text: text, timestamp: timestamp.dateValue())
                }

                DispatchQueue.main.async {
                    self?.posts = posts
                }
            }
    }
}
