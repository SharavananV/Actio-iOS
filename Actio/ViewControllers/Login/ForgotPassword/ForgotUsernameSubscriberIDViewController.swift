//
//  ForgotUsernameSubscriberIDViewController.swift
//  Actio
//
//  Created by apple on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ForgotUsernameSubscriberIDViewController: UIViewController {

    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailIdTextField: UITextField!
    private let service = DependencyProvider.shared.networkService
    var forgotDetails: ForgotUsernameModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        mobileNumberTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        emailIdTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        self.submitButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.submitButton.layer.cornerRadius = 5.0
        self.submitButton.clipsToBounds = true
        mobileNumberTextField.delegate = self
        emailIdTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    @IBAction func submitButtonAction(_ sender: Any) {
        getForgotUsernameDetails()

    }
    private func getForgotUsernameDetails() {
        service.post(forgotUserNameUrl,
                     parameters: ["mobileNumber": self.mobileNumberTextField.text ?? "","emailID": self.emailIdTextField.text ?? ""],
                     onView: self.view) { (response: ForgotUsernameResponse) in
            self.forgotDetails = response.result
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetAlertForgotPaaswordViewController") as? ResetAlertForgotPaaswordViewController {
                vc.resetUserName = self.forgotDetails?.username
                vc.resetSubscriptionId = self.forgotDetails?.subscriberID
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }

}
extension ForgotUsernameSubscriberIDViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
