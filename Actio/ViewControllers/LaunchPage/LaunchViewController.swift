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
    
    let dependencyProvider = DependencyProvider.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        
        let attrs1 = [NSAttributedString.Key.font: AppFont.PoppinsMedium(size: 30), NSAttributedString.Key.foregroundColor : AppColor.PurpleColor()]
        
        let attrs2 = [NSAttributedString.Key.font : AppFont.PoppinsBold(size: 38), NSAttributedString.Key.foregroundColor : AppColor.OrangeColor()]
        
        let attributedString1 = NSMutableAttributedString(string:"Welcome to\n", attributes:attrs1 as [NSAttributedString.Key : Any])
        
        let attributedString2 = NSMutableAttributedString(string:"Actio", attributes:attrs2 as [NSAttributedString.Key : Any])
        
        attributedString1.append(attributedString2)
        self.welcomeLabel.attributedText = attributedString1
        
        if UDHelper.getAuthToken().isEmpty {
            dependencyProvider.registerDatasource.prepareMasterData(with: nil, presentAlertOn: self) { (_) in
                self.performSegue(withIdentifier: "LoginPage", sender: self)
            }
        }
        else {
            dependencyProvider.registerDatasource.getUserStatus { (status) in
                switch status {
                case .success(let status):
                    self.navigateBasedOnStatus(status)
                case .failure(let message):
                    self.view.makeToast(message)
                }
            }
        }
    }
    
    private func navigateBasedOnStatus(_ status: Int) {
        switch status {
        case 1,8, 9:
            self.performSegue(withIdentifier: "showDashboard", sender: self)
        case 7:
            self.performSegue(withIdentifier: "showBeforeApproval", sender: self)
        case 5,6:
            self.performSegue(withIdentifier: "showEnterParentID", sender: self)
        case 3,4:
            self.performSegue(withIdentifier: "showOTP", sender: self)
        default:
            self.performSegue(withIdentifier: "LoginPage", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
