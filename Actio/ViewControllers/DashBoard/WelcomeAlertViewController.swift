//
//  WelcomeAlertViewController.swift
//  Actio
//
//  Created by senthil on 22/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class WelcomeAlertViewController: UITabBarController {

    @IBOutlet var okButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    
    var loggedUserName = "Jo** S****"

    override func viewDidLoad() {
        super.viewDidLoad()
        
            self.nameLabel.text = self.loggedUserName
    

        // Do any additional setup after loading the view.
    }
    

    @IBAction func okButtonAction(_ sender: Any) {
    }

}
