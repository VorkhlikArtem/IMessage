//
//  FirestoreService.swift
//  Messager
//
//  Created by Артём on 16.12.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class FirestoreService {
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private var waitingChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    private var activeChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }
    
    var currentUser: MUser!
    
    /// we get user's info when logging in
    func getUserData(user: User, completion: @escaping (Result<MUser, Error>)-> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let mUser = MUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMUser))
                    return
                }
                self.currentUser = mUser
                completion(.success(mUser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    /// saving user's profile
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MUser, Error>)->Void ) {
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != #imageLiteral(resourceName: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var mUser = MUser(username: username!, email: email, avatarStringURL: "", sex: sex!, description: description!, id: id)
        
        StorageService.shared.uploadImage(image: avatarImage!) { result in
            switch result {
            case .success(let url):
                mUser.avatarStringURL = url.absoluteString
                
                self.usersRef.document(mUser.id).setData(mUser.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(mUser))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// we create document of messages collection if user  does not have a chat with the current user, then we add the message
    func sendMessage(message: String, receiver: MUser, completion: @escaping (Result<Void, Error>)->Void ) {
        let reference = db.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        
        let message = MMessage(user: currentUser, content: message)
        let chat = MChat(friendUsername: currentUser.username,
                         friendAvatarStringUrl: currentUser.avatarStringURL,
                         lastMessageContent: message.content,
                         friendId: currentUser.id)
        
        reference.document(currentUser.id).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
           
        }
    }
    
    func deleteWaitingChat(chat: MChat, completion: @escaping (Result<Void, Error>)->Void ) {
        waitingChatsRef.document(chat.friendId).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    func deleteMessages(chat: MChat, completion: @escaping (Result<Void, Error>)->Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else {return}
                    let messageRef = reference.document(documentId)
                    messageRef.delete { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWaitingChatMessages(chat: MChat, completion: @escaping (Result<[MMessage], Error>)->Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        var messages = [MMessage]()
        reference.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
           
            for document in querySnapshot!.documents {
                guard let message = MMessage(document: document) else {return}
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    /// we change waiting chat into active if the user accept the friend request
    func changeToActive(chat: MChat, completion: @escaping (Result<Void, Error>)->Void) {
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { result in
                    switch result {
                    case .success:
                        self.createActiveChat(chat: chat, messages: messages) { result in
                            switch result {
                            case .success:
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createActiveChat(chat: MChat, messages: [MMessage], completion: @escaping (Result<Void, Error>)->Void) {
        let messageRef = activeChatsRef.document(chat.friendId).collection("messages")
        activeChatsRef.document(chat.friendId).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for message in messages {
                messageRef.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
    func sendMessage(chat: MChat, message: MMessage, completion: @escaping (Result<Void, Error>)->Void) {
        let friendRef = usersRef.document(chat.friendId).collection("activeChats").document(currentUser.id)
        let friendMessagesRef = friendRef.collection("messages")
        let myMessagesRef = usersRef.document(currentUser.id).collection("activeChats").document(chat.friendId).collection("messages")
        
        let chatForFriend = MChat(friendUsername: currentUser.username,
                                  friendAvatarStringUrl: currentUser.avatarStringURL,
                                  lastMessageContent: message.content,
                                  friendId: currentUser.id)
        friendRef.setData(chatForFriend.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            friendMessagesRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                myMessagesRef.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
}
