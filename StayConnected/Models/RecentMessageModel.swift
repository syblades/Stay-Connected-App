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
   
    
    var timeElapsed: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
   
    // to shorten long text messages in the main messages view
    func shortText () -> String {
        let kMaxCount = 40
        if text.count < kMaxCount {
            return text
        } else {
            return "\(text.prefix(kMaxCount))..."
        }
    }
}
