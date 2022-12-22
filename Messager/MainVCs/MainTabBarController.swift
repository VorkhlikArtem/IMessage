//
//  MainTabBarController.swift
//  Messager
//
//  Created by Артём on 01.12.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let currentUser: MUser
    
    init(currentUser: MUser = MUser(username: "d", email: "d", avatarStringURL: "d", sex: "d", description: "d", id: "d")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .purple
        tabBar.backgroundColor = .white
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        
        viewControllers = [
            generateNavigationController(rootViewController: PeopleViewController(currentUser: currentUser), title: "People", image: UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)),
            generateNavigationController(rootViewController: ListViewController(currentUser: currentUser), title: "Conversation", image: UIImage(systemName: "person.2", withConfiguration: boldConfig))
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
    
}
