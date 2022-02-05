//
//  MessageLogViewModel.swift
//  StayConnected
//
//  Created by Symone Blades on 2/4/22.
//

import Foundation
import FirebaseFirestore

class MessageLogViewModel: ObservableObject {
    
    @Published var messageText = ""
    @Published var errorMessage = ""
    
    let appUser: AppUser?
    
    
    init(appUser: AppUser?) {
        self.appUser = appUser
    }
    
    func handleSend() {
        print(messageText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = appUser?.uid else { return }
        
        // saving messages to firestore storage
        let senderMessageDocument = FirebaseManager.shared.firestore.collection("messages") // collection stores all messages between users (message log view)
            .document(fromId) // stores the user who is sending the message
            .collection(toId) // collection stores all users you've sent a message to (main message log view)
            .document()
        
        let messageData = ["fromId" : fromId, "toId": toId, "text": self.messageText, "timestamp": Timestamp()] as [String : Any]
        
        senderMessageDocument.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message to firestore: \(error)"
                return
            }
            print("Hey sender, we have successfully saved your message!")
            self.messageText = "" // after the message is sent the textfield will clear out
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages") // collection stores all messages between users (message log view)
            .document(toId) // stores the user who is sending the message
            .collection(fromId) // collection stores all users you've sent a message to (main message log view)
            .document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message to firestore: \(error)"
                return
            }
            print("Hey recipient, we have successfully saved your message too!")

        }
    }
}
