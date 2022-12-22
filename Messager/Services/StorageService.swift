//
//  StorageService.swift
//  Messager
//
//  Created by Артём on 18.12.2022.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import UIKit

class StorageService {
    static let shared = StorageService()
    
    let storageRef = Storage.storage().reference()
    
    var avatarRef: StorageReference {
        storageRef.child("avatars")
    }
    
    var chatsRef: StorageReference {
        storageRef.child("chats")
    }
    
    var currentUserId: String {
        Auth.auth().currentUser!.uid
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Result<URL, Error>)->Void) {
        guard let scaledImage = image.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        avatarRef.child(currentUserId).putData(imageData, metadata: metaData) { result in
            switch result {
            case .success(_):
                self.avatarRef.child(self.currentUserId).downloadURL { result in
                    switch result {
                    case .success(let url):
                        completion(.success(url))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadMessageImage(image: UIImage, to chat: MChat, completion: @escaping (Result<URL, Error>)->Void) {
        guard let scaledImage = image.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let uid = Auth.auth().currentUser!.uid
        let chatName = [chat.friendUsername, uid].joined()
        
        chatsRef.child(chatName).child(imageName).putData(imageData, metadata: metaData) { imageData, error in
            guard let _ = imageData else {
                completion(.failure(error!))
                return
            }
            self.chatsRef.child(chatName).child(imageName).downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (Result<UIImage?, Error>)->Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte: Int64 = 1 * 1024 * 1024
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(UIImage(data: imageData)))
        }
    }
}
