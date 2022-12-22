//
//  UIView + Extension.swift
//  Messager
//
//  Created by Артём on 15.12.2022.
//

import UIKit

extension UIView {
    func applyGradient(cornerRadius: CGFloat) {
        backgroundColor = nil
        layoutIfNeeded()
        let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.2364891187, green: 0.691270674, blue: 1, alpha: 1), endColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = bounds
            gradientLayer.cornerRadius = cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        }
        
    }
}
