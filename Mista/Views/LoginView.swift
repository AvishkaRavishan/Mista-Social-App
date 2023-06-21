//
//  LoginView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-20.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Login") {
                // Call the loginUser method from FirebaseAuthService passing the email and password
                FirebaseAuthService().loginUser(email: email, password: password) { result in
                    switch result {
                    case .success(let user):
                        // Handle successful login, e.g., navigate to HomeView
                        print("Logged in user:", user)
                    case .failure(let error):
                        // Handle login failure, e.g., display an error message
                        print("Login error:", error.localizedDescription)
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}
