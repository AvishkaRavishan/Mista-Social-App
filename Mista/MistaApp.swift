//
//  MistaApp.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-19.
//

import SwiftUI
import Firebase

@main
struct MistaApp: App {
    @StateObject private var firestoreService = FirestoreService()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firestoreService)
        }
    }
}
