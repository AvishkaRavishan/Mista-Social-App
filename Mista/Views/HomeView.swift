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
        VStack {
            Text("Home")
                .font(.largeTitle)
                .padding()
            
            Button("Fetch Posts") {
                viewModel.fetchPosts()
            }
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.posts, id: \.id) { post in
                        VStack {
                            Text(post.text)
                                .font(.headline)
                                .padding()
                            
                            // Add image display logic here
                            if let imageURL = post.imageURL {
                                RemoteImage(imageURL: imageURL) // Updated argument label here
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                            }
                        }
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
