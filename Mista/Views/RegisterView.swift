//
//  RegisterView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-20.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = "Avishka123"
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Register") {
                // Call the registerUser method from FirebaseAuthService passing the name, email, and password
                FirebaseAuthService().registerUser(name: name, email: email, password: password) { result in
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
