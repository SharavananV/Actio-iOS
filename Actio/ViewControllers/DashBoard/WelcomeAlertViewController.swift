//
//  WelcomeAlertViewController.swift
//  Actio
//
//  Created by senthil on 23/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class WelcomeAlertViewController: UIViewController {
    
    @IBOutlet var okButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var welcomeAlertView: UIView!
    var loggedUserName = "Jo** S****"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.welcomeAlertView.layer.cornerRadius = 7
        self.welcomeAlertView.clipsToBounds = true
        self.okButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])

        self.nameLabel.text = self.loggedUserName
        self.okButton.layer.cornerRadius = 5.0
        self.okButton.clipsToBounds = true

        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func okButtonAction(_ sender: Any) {
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
            controller.modalPresentationStyle = .fullScreen

            self.present(controller, animated: false, completion: nil)
        }

    }
    
}

