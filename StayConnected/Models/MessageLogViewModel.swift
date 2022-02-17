//
//  MessageLogViewModel.swift
//  StayConnected
//
//  Created by Symone Blades on 2/4/22.
//

import Foundation
import FirebaseFirestore


struct FirebaseConstants {
   
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let profileImageURL = "profileImageURL"
    static let username = "username"
    
}
struct AppMessage:Identifiable {
    
    // when you confirm to indentifible you have to declare an id.
    // This is so we can use AppMessage in the message log view
    var id: String { documentId }
    
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
    @Published var count = 0

    
    var appUser: AppUser?
    var toId: String?
    
    
    init(toId: String?) {
        self.toId = toId
        fetchUser { [weak self] in // capture self weakly 'in' seperates parameter
        self?.fetchMessages() // capture self in anon
            
        }
    }
    
    
    init(appUser: AppUser?) {
        self.appUser = appUser
        fetchMessages()
    }
    
    
    private func fetchUser(completion: @escaping () -> ()) {
        FirebaseManager.shared.firestore.collection("users").document(toId!)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch user: \(error)"
                    print("Failed to fetch user: \(error)")
                    return
                }
                if let snapshot = documentSnapshot {
                    
                    let data = snapshot.data()
                    self.appUser = AppUser(data: data!)
                    completion()
                }
            }
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
                
                // listens for new messages ie changes in the document
                // stores all messages in a list so they are always present in the users message log view and each time a new message is added
                // the listener recognizes it, appends it to the array (message log view), and in realtime updates to the users phone
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.appMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                
                // waits for next available main thread frame
                // then it will execute the count change
                // then the scrollview proxy can animate itself properly
                DispatchQueue.main.async {
                    self.count += 1

                }
                
            }

    }
    
    
    func handleSend() {
        print(messageText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = appUser?.uid else { return }
        
        // saving messages to firestore storage
        // collection stores all messages between users (message log view)
        let senderMessageDocument = FirebaseManager.shared.firestore.collection("messages")
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
            
            self.persistRecentMessage()
            
            
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
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
    
    private func persistRecentMessage() {
        
        guard let appUser = appUser else { return }
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        fetchCurrentUser(uid: fromId) { currentUser in
            
            guard let toId = self.appUser?.uid else { return }
            
            let data = [
                FirebaseConstants.timestamp: Timestamp(),
                FirebaseConstants.text: self.messageText,
                FirebaseConstants.fromId: fromId,
                FirebaseConstants.toId: toId,
                FirebaseConstants.profileImageURL: appUser.profileImageURL,
                FirebaseConstants.username: appUser.username
            ] as [String : Any]
            
            let recipientdata = [
                FirebaseConstants.timestamp: Timestamp(),
                FirebaseConstants.text: self.messageText,
                FirebaseConstants.fromId: toId,
                FirebaseConstants.toId: fromId,
                FirebaseConstants.profileImageURL: currentUser.profileImageURL,
                FirebaseConstants.username: currentUser.username
            ] as [String : Any]
            
            
            let senderMessageDocument = FirebaseManager.shared.firestore
                .collection("recent_messages")
                .document(fromId)
                .collection("messages")
                .document(toId)
            
            let recipientMessageDocument = FirebaseManager.shared.firestore
                .collection("recent_messages")
                .document(toId)
                .collection("messages")
                .document(fromId)
              
            
            
            senderMessageDocument.setData(data) { error in
                
                if let error = error {
                    self.errorMessage = "Failed to save recent message: \(error)"
                    print("Failed to save recent message: \(error)")
                    return
                }
                
                print("Hey sender, we have successfully saved your recent message!")
            }
            
            recipientMessageDocument.setData(recipientdata) { error in
                
                if let error = error {
                    self.errorMessage = "Failed to save recent message: \(error)"
                    print("Failed to save recent message: \(error)")
                    return
                }
            }
            print("Hey recipient, we have successfully saved your recent message too!")
            
            self.messageText = "" // after the message is sent the textfield will clear out
            self.count += 1
        }
        

    }
    
    
    func fetchCurrentUser(uid: String, completion: @escaping (AppUser) -> ()){

        // fetch current user that's logged in
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
                
            }
            
            // same as self.appUser = AppUser(username: username, uid: uid, email: email, profileImageURL: profileImageURL)
            completion(.init(data: data))
            
          
        }
    }
    
}
