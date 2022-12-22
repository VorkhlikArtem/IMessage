//
//  UIScrollView + Extension.swift
//  Messager
//
//  Created by Артём on 20.12.2022.
//

import UIKit

extension UIScrollView {
    var isAtBottom: Bool {
        contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
