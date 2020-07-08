//
//  LaunchViewController.swift
//  Actio
//
//  Created by senthil on 06/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.tintColor = .white
        
        
        let attrs1 = [NSAttributedString.Key.font: AppFont.PoppinsMedium(size: 30), NSAttributedString.Key.foregroundColor : AppColor.PurpleColor()]
        
        let attrs2 = [NSAttributedString.Key.font : AppFont.PoppinsBold(size: 38), NSAttributedString.Key.foregroundColor : AppColor.OrangeColor()]
        
        let attributedString1 = NSMutableAttributedString(string:"Welcome to\n", attributes:attrs1 as [NSAttributedString.Key : Any])
        
        let attributedString2 = NSMutableAttributedString(string:"Actio", attributes:attrs2 as [NSAttributedString.Key : Any])
        
        attributedString1.append(attributedString2)
        self.welcomeLabel.attributedText = attributedString1
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @objc func timeToMoveOn() {
        self.performSegue(withIdentifier: "LoginPage", sender: self)
    }
    
}
