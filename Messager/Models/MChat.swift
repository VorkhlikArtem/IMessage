//
//  MChat.swift
//  Messager
//
//  Created by Артём on 15.12.2022.
//

import Foundation
import FirebaseFirestore

struct MChat: Hashable, Decodable {
    var friendUsername: String
    var friendAvatarStringUrl: String
    var lastMessageContent: String
    var friendId: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
    
    init(friendUsername: String, friendAvatarStringUrl: String, lastMessageContent: String, friendId: String) {
        self.friendUsername = friendUsername
        self.friendAvatarStringUrl = friendAvatarStringUrl
        self.lastMessageContent = lastMessageContent
        self.friendId = friendId
    }
}

extension MChat {
    var representation: [String: Any] {
        var rep = ["friendUsername": friendUsername]
        rep["friendAvatarStringUrl"] = friendAvatarStringUrl
        rep["lastMessage"] = lastMessageContent
        rep["friendId"] = friendId
        return rep
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendUsername = data["friendUsername"] as? String,
              let friendAvatarStringUrl = data["friendAvatarStringUrl"] as? String,
              let lastMessageContent = data["lastMessage"] as? String,
              let friendId = data["friendId"] as? String else {return nil}
        self.friendUsername = friendUsername
        self.friendAvatarStringUrl = friendAvatarStringUrl
        self.lastMessageContent = lastMessageContent
        self.friendId = friendId
 
    }
}
