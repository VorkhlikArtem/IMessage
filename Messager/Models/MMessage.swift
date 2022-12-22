//
//  MMessage.swift
//  Messager
//
//  Created by Артём on 19.12.2022.
//

import Foundation
import FirebaseFirestore
import MessageKit
import UIKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct ImageItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

struct MMessage: Hashable, MessageType {
    
    var sender: SenderType
    let content: String
    var sentDate: Date
    let id: String?
    
    var messageId: String {
        id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        if let image = image {
            let imageItem = ImageItem(url: nil, image: nil, placeholderImage: image, size: image.size)
            return .photo(imageItem)
        } else {
            return .text(content)
        }
        
    }
    
    var image: UIImage? = nil
    var downloadUrl: URL? = nil
    
    init(user: MUser, content: String) {
        sender = Sender(senderId: user.id, displayName: user.username)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(user: MUser, image: UIImage) {
        sender = Sender(senderId: user.id, displayName: user.username)
        self.image = image
        self.content = ""
        sentDate = Date()
        id = nil
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        lhs.messageId == rhs.messageId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
}

extension MMessage {
    var representation: [String: Any] {
        var rep = [String: Any]()
        rep["senderId"] = sender.senderId
        rep["senderUserName"] = sender.displayName
        rep["created"] = sentDate
        rep["id"] = id
        
        if let url = downloadUrl {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        return rep
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp,
              let senderId = data["senderId"] as? String,
              let senderUserName = data["senderUserName"] as? String else {return nil}
        self.sentDate = sentDate.dateValue()
        self.id = document.documentID
        self.sender = Sender(senderId: senderId, displayName: senderUserName)
      
        if let content = data["content"] as? String {
            self.content = content
            self.downloadUrl = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            self.downloadUrl = url
            self.content = ""
        } else {
            return nil
        }
    }
}

extension MMessage: Comparable {
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}
