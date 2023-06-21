//
//  PostView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-21.
//

import Foundation
import SwiftUI

struct PostView: View {
    @State private var isLiked = false
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageURL = post.imageURL {
                // Display the post image if available
                RemoteImage(imageURL: imageURL)
                    .aspectRatio(contentMode: .fit)
            }
        HStack {
            Text(post.text)
                .font(.headline)
                .padding(.vertical)
            
            Spacer() // Add spacer to push the like buttons to the bottom
            
            
//                Spacer()
                
                Button(action: {
                    isLiked.toggle()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .gray)
                }
                
//                Button(action: {
//                    // Add unlike functionality here
//                }) {
//                    Image(systemName: "hand.thumbsdown")
//                        .foregroundColor(.gray)
//                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}
