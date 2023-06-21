//
//  ContentView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-19.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = FirebaseAuthService()
    @StateObject private var firestoreManager = FirestoreService()

    var body: some View {
        NavigationView {
            if authManager.isAuthenticated {
                HomeView()
                    .environmentObject(firestoreManager)
            } else {
                HomeView()
                    .environmentObject(authManager)
            }
        }
        .onAppear {
            authManager.configureFirebaseAuthStateListener()
        }
        .onDisappear {
            authManager.removeFirebaseAuthStateListener()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
