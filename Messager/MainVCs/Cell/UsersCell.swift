//
//  UsersCell.swift
//  Messager
//
//  Created by Артём on 15.12.2022.
//

import UIKit
import SDWebImage

class UsersCell: UICollectionViewCell, SelfConfiguringCell {

    static var reuseId: String = "UsersCell"
    
    let userImageView = UIImageView()
    let contaiverView = UIView()
    let userNameLabel = UILabel(text: "UserName", font: UIFont.loaSangamMN20())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        layer.cornerRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowRadius = 3
        
        userImageView.clipsToBounds = true
        userImageView.contentMode = .scaleAspectFill
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contaiverView.layer.cornerRadius = 5
        contaiverView.clipsToBounds = true
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let user = value as? MUser else {return}
        userNameLabel.text = user.username
        guard let url = URL(string: user.avatarStringURL) else {return}
        userImageView.sd_setImage(with: url, completed: nil)
    }

    func setupConstraints() {
        contaiverView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contaiverView)
        contaiverView.addSubview(userImageView)
        contaiverView.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            contaiverView.topAnchor.constraint(equalTo: topAnchor),
            contaiverView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contaiverView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contaiverView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: contaiverView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: contaiverView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: contaiverView.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: contaiverView.leadingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: contaiverView.trailingAnchor, constant: -8),
            userNameLabel.bottomAnchor.constraint(equalTo: contaiverView.bottomAnchor)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
