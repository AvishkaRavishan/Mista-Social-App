//
//  UserProfileView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-20.
//

import SwiftUI

struct UserProfileView: View {
    var user: User
    
    var body: some View {
        VStack {
            Text("User Profile")
                .font(.largeTitle)
                .padding()
            
            // Display user information, such as email
            Text("Email: \(user.email)")
        }
    }
}
