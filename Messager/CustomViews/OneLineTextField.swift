//
//  OneLineTextField.swift
//  Messager
//
//  Created by Артём on 30.11.2022.
//

import UIKit

class OneLineTextField: UITextField {
    
    convenience init(font: UIFont? = .avenir20()) {
        self.init()
        
        self.font = font
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = .grayTextFieldColor
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomLineView)
        
        NSLayoutConstraint.activate([
            bottomLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)])
    }
}
