//
//  ResetAlertForgotPaaswordViewController.swift
//  Actio
//
//  Created by apple on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ResetAlertForgotPaaswordViewController: UIViewController {

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var subscriptionIdLabel: UILabel!
    var resetUserName: String?
    var resetSubscriptionId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertView.layer.cornerRadius = 7
        self.alertView.clipsToBounds = true
        self.okButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        
        self.nameLabel.text = resetUserName
        self.subscriptionIdLabel.text = resetSubscriptionId

        self.okButton.layer.cornerRadius = 5.0
        self.okButton.clipsToBounds = true
    }

    @IBAction func okButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.navigationController?.pushViewController(vc, animated: false)
        }

    }
}
