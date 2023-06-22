//
//  User.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-19.
//

import Foundation
import Firebase

struct User {
    let id: String?
    let name: String
    let email: String
    
    init(id: String?, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    init(authData: Firebase.User) {
        self.id = authData.uid
        self.name = ""
        self.email = authData.email ?? ""
        // You can fetch the username from Firestore or set it to an empty string if not available
    }
}
