//
//  AppUser.swift
//  StayConnected
//
//  Created by Symone Blades on 2/1/22.
//

import Foundation
import FirebaseFirestore


struct AppUser: Identifiable {
    
    var id: String { uid } // getter syntax. For every Identifable need a variable
    
    let username, uid, email, profileImageURL, timestamp: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.timestamp = data["timestamp"] as? String ?? ""

    }
    
}
 



//if let error = error {
//    self.errorMessage = "Failed to listen for recent messages: \(error)"
//    print(error)
//    return
//}
