//
//  UIApplication + Extension.swift
//  Messager
//
//  Created by Артём on 18.12.2022.
//

import UIKit

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.currentKeyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}


extension UIApplication {
    static var currentKeyWindow: UIWindow? {
        Self.shared.connectedScenes
            .filter{$0.activationState == .foregroundActive}
            .map{$0 as? UIWindowScene}
            .compactMap{$0}
            .first?.windows
            .filter{$0.isKeyWindow}.first
    }
    
}
