//
//  BeforeApprovalViewController.swift
//  Actio
//
//  Created by apple on 17/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class BeforeApprovalViewController: UIViewController {

    @IBOutlet weak var stepsView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var stepsHeadingLabel: UILabel!
    @IBOutlet weak var actualStepsLabel: UILabel!
    
    var parentName = "Jo** S****"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentView.layer.cornerRadius = 7
        self.stepsView.applyGradient(colours: [AppColor.RedColor(), AppColor.OrangeColor()])
        
        let message = "We have requested \(parentName) to authorize the profile. Once it is authorized, your profile will be active"
        let normalTextAttr = [NSAttributedString.Key.font: AppFont.PoppinsRegular(size: 15)]
        if let parentRange = message.nsRange(of: parentName) {
            let attributedString = NSMutableAttributedString(string: message, attributes: normalTextAttr)
            attributedString.addAttribute(.font, value: AppFont.PoppinsSemiBold(size: 15), range: parentRange)
            messageLabel.attributedText = attributedString
        }
        
        stepsHeadingLabel.font = AppFont.PoppinsSemiBold(size: 15)
        actualStepsLabel.font = AppFont.PoppinsRegular(size: 12)
    }
}
