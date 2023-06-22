//
//  SettingsView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-21.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var authManager: FirebaseAuthService
    @State private var isPresentingLoginView = false
    @State private var isPresentingRegisterView = false
    @State private var loggedIn = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Settings Options")
                    .font(.largeTitle)
                    .padding()

                if loggedIn, let userEmail = authManager.currentUser?.email {
                    Text("Logged in as: \(userEmail)")
                        .font(.headline)
                        .padding()
                    Button("Sign Out") {
                        authManager.logoutUser { result in
                            switch result {
                            case .success:
                                loggedIn = false
                            case .failure(let error):
                                print("Sign out error:", error.localizedDescription)
                            }
                        }
                    }
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
                } else {
                    HStack(spacing: 20) {
                        Button("Login") {
                            isPresentingLoginView = true
                        }
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .sheet(isPresented: $isPresentingLoginView) {
                            LoginView(loggedIn: $loggedIn)
                        }

                        Button("Register") {
                            isPresentingRegisterView = true
                        }
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .sheet(isPresented: $isPresentingRegisterView) {
                            RegisterView()
                        }
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}
