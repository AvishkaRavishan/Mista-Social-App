//
//  PostListView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-20.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI

struct PostListView: View {
    @ObservedObject private var postViewModel = PostViewModel()
    @State private var selectedPost: Post?
    @State private var isEditingPost = false
    @Binding var posts: [Post] // Update to use a binding


    var body: some View {
        NavigationView {
            VStack {
                // Add any header view you want
                
                List {
                    ForEach(postViewModel.posts) { post in
                        NavigationLink(destination: PostDetailView(post: post)) {
                            HStack {
                                if let imageURL = post.imageURL {
                                    WebImage(url: URL(string: imageURL))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(5)
                                        .padding(.trailing, 10) // Add padding to create consistent spacing
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(5)
                                        .padding(.trailing, 10) // Add padding to create consistent spacing
                                }

                                VStack(alignment: .leading) {
                                    Text(post.text)
                                        .font(.headline)
                                }
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button(action: {
                                // Navigate to EditPostView
                                selectedPost = post
                                isEditingPost = true
                            }) {
                                Label(NSLocalizedString("edit", comment: ""), systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
//                    .onDelete { indexSet in
//                        guard let index = indexSet.first else {
//                            return
//                        }
//                        let postToDelete = postViewModel.posts[index]
//                        postViewModel.deletePost(postToDelete) { error in
//                            if let error = error {
//                                // Handle the error
//                                print("Error deleting post: \(error.localizedDescription)")
//                            } else {
//                                // Post deleted successfully
//                                postViewModel.fetchPosts { result in
//                                    switch result {
//                                    case .success(let posts):
//                                        // Handle successful post retrieval
//                                        print("Fetched posts: \(posts)")
//                                    case .failure(let error):
//                                        // Handle error
//                                        print("Error fetching posts: \(error.localizedDescription)")
//                                    }
//                                }
//                            }
//                        }
//                    }
                    .onMove { indices, newOffset in
                        postViewModel.posts.move(fromOffsets: indices, toOffset: newOffset)
                        // TODO: Update the order of posts in Firebase or perform any necessary actions
                    }
                }
                .listStyle(PlainListStyle())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                .sheet(item: $selectedPost) { post in
                    NavigationView {
                        EditPostView(post: post, onSave: { editedText in
                            // Handle saving the edited post
                        })
                        .navigationBarItems(leading: Button("Cancel") {
                            isEditingPost = false
                            selectedPost = nil
                        })
                    }
                }
                .onAppear {
                    postViewModel.fetchPosts { result in
                        switch result {
                        case .success(let posts):
                            // Handle successful post retrieval
                            print("Fetched posts: \(posts)")
                        case .failure(let error):
                            // Handle error
                            print("Error fetching posts: \(error.localizedDescription)")
                        }
                    }
                }
                .navigationTitle(NSLocalizedString("posts", comment: ""))
            }
        }
        .accentColor(.blue)
    }
}
