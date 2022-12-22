//
//  ActiveChatCell.swift
//  Messager
//
//  Created by Артём on 02.12.2022.
//

import UIKit
import SDWebImage

class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {
 
    static let reuseId = "ActiveChatCell"
    
    let friendImageView = UIImageView()
    let friendName = UILabel(text: "User name", font: UIFont.loaSangamMN20())
    let lastMessage = UILabel(text: "How are you?", font: UIFont.loaSangamMN18())
    let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), endColor: #colorLiteral(red: 0.5246731163, green: 0.3341386839, blue: 0.9240180748, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 4
        clipsToBounds = true
        friendImageView.clipsToBounds = true
        friendImageView.layer.cornerRadius = 4
        friendImageView.contentMode = .scaleAspectFill
        
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendImageView.image = nil
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let chat = value as? MChat else {return}
        friendImageView.sd_setImage(with: URL(string: chat.friendAvatarStringUrl), completed: nil)
        friendName.text = chat.friendUsername
        lastMessage.text = chat.lastMessageContent
    }
 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - setup Constraints
extension ActiveChatCell {
    private func setupConstraints() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendName.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        friendImageView.backgroundColor = .green
        gradientView.backgroundColor = .black
        
        self.contentView.addSubview(friendImageView)
        self.contentView.addSubview(gradientView)
        self.contentView.addSubview(friendName)
        self.contentView.addSubview(lastMessage)

        
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalToConstant: 78)  ])
        
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8)  ])
        
        NSLayoutConstraint.activate([
            friendName.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 20),
            friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            lastMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 20),
            lastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -20)
        ])
    }
}

//MARK: - SwiftUI
import SwiftUI
struct ActiveChatProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().ignoresSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = MainTabBarController()
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }

        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
    }
}
