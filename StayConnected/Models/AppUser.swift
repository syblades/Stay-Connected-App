//
//  AppUser.swift
//  StayConnected
//
//  Created by Symone Blades on 2/1/22.
//

import Foundation

struct AppUser {
    let username, uid, email, profileImageURL: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
    }
    
}
