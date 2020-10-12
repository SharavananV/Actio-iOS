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
