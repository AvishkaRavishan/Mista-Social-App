//
//  PostListView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-20.
//

import Foundation
import SwiftUI

struct PostListView: View {
    var posts: [Post]
    
    var body: some View {
        List(posts, id: \.id) { post in
            VStack {
                // Display post information, such as text and image
                Text(post.text)
                // Add image display logic here
            }
        }
    }
}
