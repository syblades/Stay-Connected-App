//
//  RecentMessageModel.swift
//  StayConnected
//
//  Created by Symone Blades on 2/8/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


// identifiable so we can use ForEach loop
struct RecentMessage : Codable, Identifiable {
    
    @DocumentID var id: String?
    let text, username: String
    let fromId, toId: String
    let profileImageURL: String
    let timestamp: Date
    
}
