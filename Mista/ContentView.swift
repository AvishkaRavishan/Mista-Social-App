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
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(NSLocalizedString("Home", comment: ""))
                }
            
            ChatView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text(NSLocalizedString("Chat", comment: ""))
                }
            
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text(NSLocalizedString("Notifications", comment: ""))
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text(NSLocalizedString("Settings", comment: ""))
                }
        }
        .environmentObject(authManager) // Add the FirebaseAuthService as an environment object
        .environmentObject(firestoreManager) // Add the FirestoreService as an environment object
    }
}



//struct ContentView: View {
//    @StateObject private var authManager = FirebaseAuthService()
//    @StateObject private var firestoreManager = FirestoreService()
//
//    var body: some View {
//        NavigationView {
//            if authManager.isAuthenticated {
//                HomeView()
//                    .environmentObject(firestoreManager)
//            } else {
//                HomeView()
//                    .environmentObject(authManager)
//            }
//        }
//        .onAppear {
//            authManager.configureFirebaseAuthStateListener()
//        }
//        .onDisappear {
//            authManager.removeFirebaseAuthStateListener()
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
