//
//  LoginView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-20.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email = "avishk678@gmail.com"
    @State private var password = "Avishka123"
    @State private var showAlert = false
    @State private var isPasswordVisible = false
    @Binding var loggedIn: Bool
    @EnvironmentObject private var authManager: FirebaseAuthService

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            Button("Login") {
                // Call the loginUser method from FirebaseAuthService passing the email and password
                authManager.loginUser(email: email, password: password) { result in
                    switch result {
                    case .success(let user):
                        // Handle successful login, e.g., navigate to HomeView
                        showAlert = true
                        loggedIn = true
                        print("Logged in user:", user)
                    case .failure(let error):
                        // Handle login failure, e.g., display an error message
                        print("Login error:", error.localizedDescription)
                    }
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Logged in as \(email)"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
    }
}
