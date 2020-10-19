//
//  ChildLogoutWarningViewController.swift
//  Actio
//
//  Created by senthil on 23/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ChildLogoutWarningViewController: UIViewController {
    private let dependencyProvider = DependencyProvider.shared
	private let service = DependencyProvider.shared.networkService
    weak var delegate: LogoutDelegate?

    @IBOutlet var okButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var alertView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.okButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.cancelButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        
        self.okButton.layer.cornerRadius = 5.0
        self.okButton.clipsToBounds = true

        self.cancelButton.layer.cornerRadius = 5.0
        self.cancelButton.clipsToBounds = true
        
        self.alertView.layer.cornerRadius = 5.0
        self.alertView.clipsToBounds = true
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)

    }
	
    @IBAction func okButtonAction(_ sender: Any) {
		self.dependencyProvider.registerDatasource.logout(presentAlertOn: self) { (message) in
            UDHelper.resetUserStuff()

            self.view.makeToast(message)
            
            if message == "Logout Success" {
                if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false, completion: nil)
                }
            }

        }
        
    }
    func logout(completion: @escaping ((String) -> Void)) {
		service.post(logoutUrl, parameters: ["Mode":"1", "deviceToken": UDHelper.getDeviceToken()], onView: view) { (response) in
			UDHelper.resetUserStuff()
		}
	}
}
