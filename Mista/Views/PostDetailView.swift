//
//  PostDetailView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-21.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post

    var body: some View {
        VStack {
            if let imageURL = post.imageURL {
                RemoteImage(imageURL: imageURL)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            }

            Text(post.text)
                .font(.headline)
                .padding()
            
            Text(post.timestamp, style: .relative)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom)
        }
        .navigationTitle("Post Details")
    }
}

