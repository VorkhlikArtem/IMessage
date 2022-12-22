//
//  WaitingChatsNavigationDelegate.swift
//  Messager
//
//  Created by Артём on 19.12.2022.
//

import Foundation

protocol WaitingChatsNavigationDelegate: AnyObject {
    func denyChat(chat: MChat)
    func addToActive(chat: MChat)
}
