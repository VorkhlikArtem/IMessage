//
//  WaitingChatCell.swift
//  Messager
//
//  Created by Артём on 02.12.2022.
//

import UIKit
import SDWebImage

class WaitingChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "WaitingChatCell"
    
    let friendImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
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
    }
    
    func setupConstraints() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(friendImageView)
        NSLayoutConstraint.activate([
            friendImageView.topAnchor.constraint(equalTo: topAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            friendImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: trailingAnchor)

        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
