//
//  MainMessages.swift
//  StayConnected
//
//  Created by Symone Blades on 2/1/22.
//

import Foundation

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var appUser: AppUser?
    
    init() {
        
        // so there isnt any lag in presenting the cover
        DispatchQueue.main.async {
            
            // if UserCurrentlyLoggedOut is true it will by default present the cover to the login view
            self.UserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil // checking if uid exists in the FireBase manager shared auth variable. if it's nil means user isnt logged in and UserCurrenlyLoggedOut evaluates to true
        }
        
        
        fetchCurrentUser()
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
    
    @Published var UserCurrentlyLoggedOut = false
    
    func handleLogOut() {
        UserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut() // signs user out of firestore db
    }
}
