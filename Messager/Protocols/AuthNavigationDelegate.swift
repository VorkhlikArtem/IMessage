//
//  AuthNavigationDelegate.swift
//  Messager
//
//  Created by Артём on 16.12.2022.
//

import Foundation

protocol AuthNavigationDelegate: AnyObject {
    func presentLoginVC()
    func presentSignupVC()
}
