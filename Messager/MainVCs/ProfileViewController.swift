//
//  ProfileViewController.swift
//  Messager
//
//  Created by Артём on 15.12.2022.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    let containerView = UIView()
    let userImageView = UIImageView(image: #imageLiteral(resourceName: "artem"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Artem Vorkhlik", font: .systemFont(ofSize: 20, weight: .light))
    let aboutMeLabel = UILabel(text: "I'm fine", font: .systemFont(ofSize: 16, weight: .light))
    let textField = InsertableTextField()
    
    private let user: MUser
    
    init(mUser: MUser) {
        self.user = mUser
        userImageView.sd_setImage(with:  URL(string: mUser.avatarStringURL), completed: nil)
        nameLabel.text = mUser.username
        aboutMeLabel.text = mUser.description
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeElements()
        setupConstraints()
    }
    
    private func customizeElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        aboutMeLabel.numberOfLines = 0
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = .backgroundColor
   
        if let tfButton = textField.rightView as? UIButton {
            tfButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }
    
    @objc private func sendMessage() {
        guard let message = textField.text, !message.isEmpty else {return}
        self.dismiss(animated: true) {
            FirestoreService.shared.sendMessage(message: message, receiver: self.user) { result in
                switch result {
                    
                case .success:
                    UIApplication.getTopViewController()?.presentAlert(withTitle: "Success" , andMessage: "Message was sent to \(self.user.username)")
                case .failure(let error):
                    UIApplication.getTopViewController()?.presentAlert(withTitle: "Error", andMessage: error.localizedDescription)

                }
            }
        }
    }
}

extension ProfileViewController {
    private func setupConstraints() {
        view.addSubview(userImageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(textField)
    
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 210),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userImageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            userImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }
}




