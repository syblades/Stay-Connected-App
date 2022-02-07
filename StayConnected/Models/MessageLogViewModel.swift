//
//  MessageLogViewModel.swift
//  StayConnected
//
//  Created by Symone Blades on 2/4/22.
//

import Foundation
import FirebaseFirestore


struct FirebaseConstants {
    // declaring the attributes as constants
    // instead of using hard coded string values in various places in code base. Declare constants
    // so update in one place
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    
}
struct AppMessage:Identifiable {
    
    var id: String { documentId } // when you confirm to indentifible you have to declare an id. This is so we can use AppMessage in the message log view
    
    let documentId: String
    let fromId, toId, text, timestamp: String
    
    // turning keys into strings to use in fetch messages func
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.timestamp = data[FirebaseConstants.timestamp] as? String ?? ""

    }
}

class MessageLogViewModel: ObservableObject {
    
    @Published var messageText = ""
    @Published var errorMessage = ""
    
    @Published var appMessages = [AppMessage]()
    
    let appUser: AppUser?
    
    
    init(appUser: AppUser?) {
        self.appUser = appUser
        
        fetchMessages()
    }
    
    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = appUser?.uid else { return }
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                // listens for new messages ie changes in the document. stores all messages in a list so they are always present in the users message log view and each time a new message is added the listener recognizes it and appends it to the array (message log view) and in realtime updates to the user phone
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.appMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
            }

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
        
        let messageData = [FirebaseConstants.fromId : fromId, FirebaseConstants.toId: toId, FirebaseConstants.text: self.messageText, FirebaseConstants.timestamp: Timestamp()] as [String : Any]
        
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
