//
//  ForgotPasswordViewController.swift
//  Actio
//
//  Created by apple on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var subscriptionIdTextField: UITextField!
    private let service = DependencyProvider.shared.networkService
    var forgotDetails: ForgotPasswordModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptionIdTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        self.submitButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.submitButton.layer.cornerRadius = 5.0
        self.submitButton.clipsToBounds = true
        subscriptionIdTextField.delegate = self
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        getForgotDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    private func getForgotDetails() {
        service.post(forgotPasswordUrl,
                     parameters: ["username": self.subscriptionIdTextField.text ?? "" ],
                     onView: self.view) { (response: ForgotPasswordModel) in
            self.forgotDetails = response
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtpViewController") as? OtpViewController {
                vc.fromController = .forgotPassword
                vc.username = response.username
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }

}
extension ForgotPasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
