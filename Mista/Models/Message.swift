//
//  Message.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-21.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id: String?
    let text: String
    let sender: String
    let timestamp: Date
    
    // Other properties and initializers
    
    init(id: String?, text: String, sender: String, timestamp: Date) {
        self.id = id
        self.text = text
        self.sender = sender
        self.timestamp = timestamp
    }
    
    static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}
