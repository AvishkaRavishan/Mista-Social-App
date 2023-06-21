//
//  HomeView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-20.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.posts) { post in
                        PostView(post: post)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Home")
            .onAppear {
                viewModel.fetchPosts()
            }
        }
    }
}

//struct PostView: View {
//    let post: Post
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            if let imageURL = post.imageURL {
//                // Display the post image if available
//                RemoteImage(imageURL: imageURL)
//                    .aspectRatio(contentMode: .fit)
//            }
//
//            Text(post.text)
//                .font(.headline)
//                .padding(.vertical)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
//    }
//}
