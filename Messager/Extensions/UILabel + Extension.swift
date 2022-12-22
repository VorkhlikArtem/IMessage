//
//  UILabel + Extension.swift
//  Messager
//
//  Created by Артём on 30.11.2022.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        self.text = text
        self.font = font
    }
}
