//
//  FirestoreService.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Combine

class FirestoreService: ObservableObject {
    @Published var posts: [Post] = []

    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()

    // Fetch all posts
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        firestore.collection("posts").addSnapshotListener { [weak self] snapshot, error in
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



    // Create a new post (without authentication)
    func createPost(_ post: Post, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let data = try self.postData(from: post)
            
            firestore.collection("posts").addDocument(data: data) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let postId = post.id ?? "" // Use nil-coalescing operator to provide a default value
                    completion(.success(postId))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }



    // Update an existing post
    func updatePost(_ post: Post, completion: @escaping (Error?) -> Void) {
        do {
            let data = try self.postData(from: post)
            guard let postID = post.id else {
                completion(nil) // Post ID is nil, return early
                return
            }

            firestore.collection("posts").document(postID).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }

    // Delete a post
    func deletePost(_ post: Post, completion: @escaping (Error?) -> Void) {
        guard let postID = post.id else {
            return
        }

        firestore.collection("posts").document(postID).delete { error in
            completion(error)
        }
    }

    // Search posts with a keyword
    func searchPosts(with keyword: String, completion: @escaping ([Post]) -> Void) {
        firestore.collection("posts")
            .whereField("text", isGreaterThanOrEqualTo: keyword)
            .whereField("text", isLessThan: keyword + "z")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    completion([])
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let posts = documents.compactMap { document -> Post? in
                    guard let data = document.data() as? [String: Any] else {
                        return nil
                    }
                    return self.post(from: data, withID: document.documentID)
                }

                completion(posts)
            }
    }

    // Convert a post to dictionary representation
    private func postData(from post: Post) throws -> [String: Any] {
        var data: [String: Any] = [:]
        data["text"] = post.text
        data["imageURL"] = post.imageURL
        data["timestamp"] = post.timestamp
        // Add other post properties as needed
        return data
    }

    // Convert a dictionary to a post with the given ID
    private func post(from data: [String: Any], withID id: String) -> Post? {
        guard let text = data["text"] as? String,
              let imageURL = data["imageURL"] as? String,
              let timestamp = data["timestamp"] as? Timestamp else {
            return nil
        }

        let post = Post(id: id, imageURL: imageURL, text: text, timestamp: timestamp.dateValue())
        return post
    }

    // Upload an image to Firebase Storage
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
            completion(.failure(error))
            return
        }
        
        let fileName = UUID().uuidString + ".jpg" // Add the file extension to the filename
        let storageRef = storage.reference().child("images/\(fileName)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let downloadURL = url?.absoluteString {
                    completion(.success(downloadURL))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])
                    completion(.failure(error))
                }
            }
        }
        
        // Observe the progress of the upload task if needed
        uploadTask.observe(.progress) { snapshot in
            // You can handle progress updates here if desired
        }
    }

}
