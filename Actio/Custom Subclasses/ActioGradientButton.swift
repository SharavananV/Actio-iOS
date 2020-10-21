//
//  ActioGradientButton.swift
//  Actio
//
//  Created by Arun Eswaramurthi on 07/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

@IBDesignable
class ActioGradientButton: UIButton {

    /// Corner radius of the background rectangle
    @IBInspectable
    public var roundRectCornerRadius: CGFloat = 7 {
        didSet {
            self.setNeedsLayout()
        }
    }

    /// Color of the background rectangle
    @IBInspectable
    public var roundRectColor: UIColor = UIColor.white {
        didSet {
            self.setNeedsLayout()
        }
    }
	
	var insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
	
	func padding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
		self.frame = CGRect(x: 0, y: 0, width: self.frame.width + left + right, height: self.frame.height + top + bottom)
		insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
	}
	
	override var intrinsicContentSize: CGSize {
		get {
			var contentSize = super.intrinsicContentSize
			contentSize.height += insets.top + insets.bottom
			contentSize.width += insets.left + insets.right
			return contentSize
		}
	}

    // MARK: Overrides
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }

    // MARK: Private
    private var roundRectLayer: CALayer?

    private func layoutRoundRectLayer() {
        if let existingLayer = roundRectLayer {
            existingLayer.removeFromSuperlayer()
        }
		
		let gradient: CAGradientLayer = CAGradientLayer()
		gradient.frame = self.bounds
		gradient.colors = [#colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1), #colorLiteral(red: 0.7803921569, green: 0, blue: 0.2235294118, alpha: 1)].map { $0.cgColor }
		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 1, y: 0)
		gradient.cornerRadius = roundRectCornerRadius
		self.layer.insertSublayer(gradient, at: 0)
		self.roundRectLayer = gradient
	}

}
