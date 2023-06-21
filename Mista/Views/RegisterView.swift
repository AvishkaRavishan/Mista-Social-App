//
//  RegisterView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-20.
//

import Foundation
import SwiftUI

struct RegisterView: View {
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
            
            Button("Register") {
                // Call the registerUser method from FirebaseAuthService passing the email and password
                FirebaseAuthService().registerUser(email: email, password: password) { result in
                    switch result {
                    case .success(let user):
                        // Handle successful registration, e.g., navigate to HomeView
                        print("Registered user:", user)
                    case .failure(let error):
                        // Handle registration failure, e.g., display an error message
                        print("Registration error:", error.localizedDescription)
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}
