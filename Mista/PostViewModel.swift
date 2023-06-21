//
//  PostViewModel.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-21.
//

import Foundation
import FirebaseFirestore

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private let firestore = Firestore.firestore()
    
    // Fetch all posts
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        firestore.collection("posts").getDocuments { [weak self] snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }

            let posts = documents.compactMap { document -> Post? in
                guard let data = document.data() as? [String: Any] else {
                    return nil
                }
                return self?.post(from: data, withID: document.documentID)
            }

            DispatchQueue.main.async {
                self?.posts = posts
                completion(.success(posts))
            }
        }
    }
    
    // Create a new post
    func createPost(withText text: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let data: [String: Any] = [
            "text": text,
            // Add other post properties as needed
        ]
        
        firestore.collection("posts").addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Update a post
    func updatePost(_ post: Post, withText text: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let postID = post.id else {
            let error = NSError(domain: "gs://mesta-938a5.appspot.com/", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid post ID"])
            completion(.failure(error))
            return
        }
        
        let data: [String: Any] = [
            "text": text,
            // Add other post properties as needed
        ]
        
        firestore.collection("posts").document(postID).setData(data, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Delete a post
    func deletePost(_ post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let postID = post.id else {
            let error = NSError(domain: "gs://mesta-938a5.appspot.com/", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid post ID"])
            completion(.failure(error))
            return
        }
        
        let postRef = firestore.collection("posts").document(postID)
        
        postRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    
    // Helper method to create a Post object from Firestore data
    private func post(from data: [String: Any], withID id: String) -> Post? {
        guard let text = data["text"] as? String,
              let timestamp = data["timestamp"] as? Timestamp else {
            return nil
        }
        
        let imageURL = data["imageURL"] as? String // Make the imageURL optional
        
        return Post(id: id, imageURL: imageURL, text: text, timestamp: timestamp.dateValue())
    }
}
