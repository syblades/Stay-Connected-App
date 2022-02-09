//
//  MainMessages.swift
//  StayConnected
//
//  Created by Symone Blades on 2/1/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var appUser: AppUser?
    @Published var recentMessages = [RecentMessage]()
    @Published var UserCurrentlyLoggedOut = false

    
    
    init() {
        
            
    // if UserCurrentlyLoggedOut is true it will by default present the cover to the login view
    // checking if uid exists in the FireBase manager shared auth variable.
    // if it's nil means user isnt logged in and UserCurrenlyLoggedOut evaluates to true
    self.UserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
    
        fetchCurrentUser()
        
        fetchRecentMessages()
    }
    
    
    
    func fetchRecentMessages () {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    // every new message saved in recent message node,
                    // we remove from array if it already contains it and it will be appended
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                        
                    }
                    
                    do {
                        if let rm = try change.document.data(as: RecentMessage.self) {
                            self.recentMessages.insert(rm, at: 0)
                        }
                    } catch {
                        print(error)
                    }
                    
                    
                })
            }
    }
    
    func fetchCurrentUser() {
        
        guard let uid  =
            FirebaseManager.shared.auth.currentUser?.uid else {
                self.errorMessage = "Could not find user"
                return
            }
        

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
            self.appUser = .init(data: data)

        }
    }
        
    func handleLogOut() {
        UserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut() // signs user out of firestore db
    }
}
