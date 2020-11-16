//
//  LaunchViewController.swift
//  Actio
//
//  Created by senthil on 06/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    let dependencyProvider = DependencyProvider.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func navigateBasedOnStatus(_ status: Int) {
        switch status {
        case 1,8,9:
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
		
		if UDHelper.getAuthToken().isEmpty {
			dependencyProvider.registerDatasource.prepareMasterData(with: nil, presentAlertOn: self) { (_) in
				self.performSegue(withIdentifier: "LoginPage", sender: self)
			}
		}
		else {
			dependencyProvider.registerDatasource.getUserStatus(presentAlertOn: self) { (status) in
				switch status {
				case .success(let status):
					self.navigateBasedOnStatus(status)
				case .failure(let message):
					self.view.makeToast(message)
				}
			}
		}
    }
}
