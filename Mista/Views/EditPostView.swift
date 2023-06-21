//
//  EditPostView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-21.
//

import SwiftUI

struct EditPostView: View {
    @State private var updatedText: String

    let post: Post
    let onSave: (String) -> Void

    init(post: Post, onSave: @escaping (String) -> Void) {
        self.post = post
        self.onSave = onSave
        self._updatedText = State(initialValue: post.text)
    }

    var body: some View {
        VStack {
            Text("Edit Post")
                .font(.largeTitle)
                .padding()

            TextField("Enter post text", text: $updatedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save") {
                onSave(updatedText)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Edit Post")
    }
}

