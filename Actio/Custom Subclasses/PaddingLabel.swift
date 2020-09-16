//
//  PaddingLabel.swift
//  Actio
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
    var insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    func padding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width + left + right, height: self.frame.height + top + bottom)
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }
}
