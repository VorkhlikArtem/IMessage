//
//  ChatRequestViewController.swift
//  Messager
//
//  Created by Артём on 15.12.2022.
//

import UIKit

class ChatRequestViewController: UIViewController {
    
    let containerView = UIView()
    let userImageView = UIImageView(image: #imageLiteral(resourceName: "artem"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Artem Vorkhlik", font: .systemFont(ofSize: 20, weight: .light))
    let aboutMeLabel = UILabel(text: "I'm fine", font: .systemFont(ofSize: 16, weight: .light))
    let acceptButton = UIButton(title: "ACCEPT", titleColor: .white, backgroundColor: .black, font: UIFont.loaSangamMN20(), isWithShadow: false, corderRadius: 10)
    let denyButton = UIButton(title: "Deny", titleColor: .red, backgroundColor: .clear, font: UIFont.loaSangamMN20(), isWithShadow: false, corderRadius: 10)
    
    private let chat: MChat
    weak var delegate: WaitingChatsNavigationDelegate?
    
    init(chat: MChat) {
        self.chat = chat
        nameLabel.text = chat.friendUsername
        userImageView.sd_setImage(with: URL(string: chat.friendAvatarStringUrl), completed: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        customizeElements()
        setupConstraints()
        
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
    }
    
    @objc private func acceptButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.addToActive(chat: self.chat)
        }
    }
    
    @objc private func denyButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.denyChat(chat: self.chat)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        acceptButton.applyGradient(cornerRadius: 10)
    }
    
    private func customizeElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false

        aboutMeLabel.numberOfLines = 0
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = .backgroundColor
   
        denyButton.layer.borderColor = UIColor.red.cgColor
        denyButton.layer.borderWidth = 1.2
       
    }
    
}

extension ChatRequestViewController {
    private func setupConstraints() {
        view.addSubview(userImageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        
        let buttonsStack = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 10)
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.distribution = .fillEqually
        containerView.addSubview(buttonsStack)
    
    
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
            buttonsStack.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 22),
            buttonsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            buttonsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            buttonsStack.heightAnchor.constraint(equalToConstant: 55)
        ])
        
    }
}




