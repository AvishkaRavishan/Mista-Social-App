//
//  FirebaseAuthService.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-19.
//

import SwiftUI
import Firebase
import Combine

class FirebaseAuthService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    private var authStateListener: AuthStateDidChangeListenerHandle?

    func configureFirebaseAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else { return }
            
            if let user = user {
                self.isAuthenticated = true
                self.currentUser = User(authData: user)
            } else {
                self.isAuthenticated = false
                self.currentUser = nil
            }
        }
    }

    func removeFirebaseAuthStateListener() {
        if let authStateListener = authStateListener {
            Auth.auth().removeStateDidChangeListener(authStateListener)
        }
    }

    func registerUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }

            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                let newUser = User(id: result.user.uid, email: email)
                self.currentUser = newUser
                completion(.success(newUser))
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }

            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                let loginUser = User(authData: result.user)
                self.currentUser = loginUser
                completion(.success(loginUser))
            }
        }
    }

    func logoutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
