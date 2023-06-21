//
//  Post.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-19.
//

import Foundation

struct Post: Identifiable {
    let id: String?
    let imageURL: String? // URL of the image
    let text: String
    let timestamp: Date
    // Add other post properties as needed
    
    init(id: String?, imageURL: String?, text: String, timestamp: Date) {
        self.id = id
        self.imageURL = imageURL
        self.text = text
        self.timestamp = timestamp
    }
}
