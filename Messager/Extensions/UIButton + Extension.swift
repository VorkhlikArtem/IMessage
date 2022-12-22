//
//  UIButton + Extension.swift
//  Messager
//
//  Created by Артём on 30.11.2022.
//

import UIKit

extension UIButton {
    convenience init(title: String,
                     titleColor: UIColor,
                     backgroundColor: UIColor,
                     font: UIFont? = .avenir20(),
                     isWithShadow: Bool = false,
                     corderRadius: CGFloat = 4) {
        self.init(type: .system)
       
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = corderRadius
        
        if isWithShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    func costomizeGoogleButton() -> UIButton {
        let googleLogo = #imageLiteral(resourceName: "googleLogo")
        let googleImageView = UIImageView(image: googleLogo, contentMode: .scaleAspectFit)
        googleImageView.translatesAutoresizingMaskIntoConstraints = false
        googleImageView.isUserInteractionEnabled = false
        self.addSubview(googleImageView)
        googleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
        googleImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return self
    }
}
