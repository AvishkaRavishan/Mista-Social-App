//
//  FirebaseAuthService.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-19.
//

import SwiftUI
import Firebase
import Combine
import Foundation
import FirebaseAuth


class FirebaseAuthService: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    private var authStateListener: AuthStateDidChangeListenerHandle?

    init() {
        configureFirebaseAuthStateListener()
    }

    deinit {
        removeFirebaseAuthStateListener()
    }

    func configureFirebaseAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else { return }

            if let user = user {
                self.isLoggedIn = true
                self.currentUser = User(authData: user)
            } else {
                self.isLoggedIn = false
                self.currentUser = nil
            }
        }
    }

    func removeFirebaseAuthStateListener() {
        if let authStateListener = authStateListener {
            Auth.auth().removeStateDidChangeListener(authStateListener)
        }
    }

    func registerUser(name: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                let newUser = User(id: result.user.uid, name: name, email: email)
                completion(.success(newUser))
            }
        }
    }



    func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }

            if let error = error {
                completion(.failure(error))
                print("Login error:", error.localizedDescription)
            } else if let result = result {
                // The currentUser will be updated automatically through the authStateListener
                let loginUser = User(authData: result.user)
                completion(.success(loginUser))
                print("Logged in user:", loginUser)
            }
        }
    }

    func logoutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
