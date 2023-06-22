//
//  ChatView.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-21.
//

import SwiftUI
import Firebase
import Combine

struct ChatView: View {
    @State private var messageText = ""
    @State private var messages: [Message] = []
    @EnvironmentObject var authManager: FirebaseAuthService // Assuming you have an AuthManager that handles authentication
    @EnvironmentObject var firestoreManager: FirestoreService
    
    var body: some View {
        VStack {
            if let currentUser = authManager.currentUser {
                Text(currentUser.email ?? "") // Display current user's email
                    .font(.headline)
                    .padding()
            } else {
                Text("Please log in to send messages") // Display a message asking the user to log in
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        MessageBubble(message: message, isCurrentUserMessage: message.sender == authManager.currentUser?.email) {
                            if message.sender == authManager.currentUser?.email {
                                deleteMessage(message)
                            }
                        }
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Type your message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
                .disabled(authManager.currentUser == nil) // Disable the button if the user is not logged in
            }
            .padding(.bottom)
        }
        .navigationBarTitle("Chat")
        .onAppear(perform: firestoreManager.receiveMessages)
        .onReceive(firestoreManager.messagesPublisher) { messages in
            self.messages = messages
        }
    }
    
    func deleteMessage(_ message: Message) {
        firestoreManager.deleteMessage(message) { result in
            switch result {
            case .success:
                if let index = messages.firstIndex(of: message) {
                    messages.remove(at: index)
                }
            case .failure(let error):
                print("Failed to delete message: \(error.localizedDescription)")
            }
        }
    }

    
    func sendMessage() {
        guard let currentUser = authManager.currentUser else {
            // Handle the case where the user is not logged in
            return
        }
        
        let newMessage = Message(id: UUID().uuidString, text: messageText, sender: currentUser.email , timestamp: Date())
        messages.append(newMessage)
        messageText = ""
        
        // Call the sendMessage function from FirestoreService
        firestoreManager.sendMessage(newMessage) { result in
            switch result {
            case .success:
                print("Message sent successfully")
            case .failure(let error):
                print("Failed to send message: \(error.localizedDescription)")
            }
        }
    }
}

struct MessageBubble: View {
    let message: Message
    let isCurrentUserMessage: Bool
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            if !isCurrentUserMessage {
                Text(message.sender)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
            } else {
                Spacer()
            }
            
            VStack(alignment: isCurrentUserMessage ? .trailing : .leading) {
                Text(message.text)
                    .padding()
                    .foregroundColor(.white)
                    .background(isCurrentUserMessage ? Color.blue : Color.green)
                    .cornerRadius(10)
            }
            .contextMenu {
                if isCurrentUserMessage {
                    Button(action: onDelete) {
                        Text("Delete")
                        Image(systemName: "trash")
                    }
                }
            }
            
            if !isCurrentUserMessage {
                Spacer()
            }
        }
    }
}
