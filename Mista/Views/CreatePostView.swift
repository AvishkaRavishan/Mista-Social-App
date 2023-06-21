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
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                TextField("Enter post text", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    self.showImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Select Image")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            .padding(.top)
            
            Spacer()
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }

            Spacer()

            Button(action: {
                createPost()
            }) {
                Text("Create Post")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .navigationBarTitle("Create Post")
    }

    private func createPost() {
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
}
