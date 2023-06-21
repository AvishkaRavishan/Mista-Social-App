//
//  CreatePostView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-20.
//

import SwiftUI

struct CreatePostView: View {
    @State private var text = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    
    @EnvironmentObject var firestoreManager: FirestoreService
    
    var body: some View {
        VStack {
            TextField("Enter post text", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Select Image") {
                self.showImagePicker = true
            }
            .padding()
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
            
            Button("Create Post") {
                
                
                if let image = selectedImage {
                    firestoreManager.uploadImage(image) { result in
                        switch result {
                        case .success(let imageURL):
                            let post = Post(id: UUID().uuidString, imageURL: imageURL, text: text, timestamp: Date())
                            firestoreManager.createPost(post) { result in
                                switch result {
                                case .success(let postID):
                                    print("Post created with ID:", postID)
                                    // Handle successful post creation
                                case .failure(let error):
                                    print("Post creation error:", error.localizedDescription)
                                    // Handle post creation error
                                }
                            }
                        case .failure(let error):
                            print("Image upload error:", error.localizedDescription)
                            // Handle image upload error
                        }
                    }
                } else {
                    let post = Post(id: UUID().uuidString, imageURL: "", text: text, timestamp: Date())
                    firestoreManager.createPost(post) { result in
                        switch result {
                        case .success(let postID):
                            print("Post created with ID:", postID)
                            // Handle successful post creation
                        case .failure(let error):
                            print("Post creation error:", error.localizedDescription)
                            // Handle post creation error
                        }
                    }
                }
            }
            .padding()
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}
