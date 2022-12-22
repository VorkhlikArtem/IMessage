//
//  UIImageView  + Extension.swift
//  Messager
//
//  Created by Артём on 30.11.2022.
//

import UIKit

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        self.image = image
        self.contentMode = contentMode
    }
}

extension UIImageView {
    func setColor(with color: UIColor) {
        let templateImage = image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        tintColor = color
    }
}
