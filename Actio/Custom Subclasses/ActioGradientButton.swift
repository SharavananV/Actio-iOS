//
//  ActioGradientButton.swift
//  Actio
//
//  Created by Arun Eswaramurthi on 07/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ActioGradientButton: UIButton {

    /// Corner radius of the background rectangle
    public var roundRectCornerRadius: CGFloat = 8 {
        didSet {
            self.setNeedsLayout()
        }
    }

    /// Color of the background rectangle
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
    private var roundRectLayer: CAShapeLayer?

    private func layoutRoundRectLayer() {
        if let existingLayer = roundRectLayer {
            existingLayer.removeFromSuperlayer()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: roundRectCornerRadius).cgPath
        shapeLayer.fillColor = roundRectColor.cgColor
        self.layer.insertSublayer(shapeLayer, at: 0)
        self.roundRectLayer = shapeLayer
        
        self.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
    }

}
