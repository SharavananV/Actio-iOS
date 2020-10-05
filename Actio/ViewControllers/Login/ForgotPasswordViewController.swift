//
//  ForgotPasswordViewController.swift
//  Actio
//
//  Created by apple on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var subscriptionIdTextField: UITextField!
    private let service = DependencyProvider.shared.networkService
    var forgotDetails: ForgotPasswordModel?
    var forgotUserName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptionIdTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        self.submitButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.submitButton.layer.cornerRadius = 5.0
        self.submitButton.clipsToBounds = true
        subscriptionIdTextField.delegate = self
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        getEventDetails()
    }
    
    private func getEventDetails() {
        service.post(forgotPasswordUrl,
                     parameters: ["subscriber_id": self.subscriptionIdTextField.text ?? "","username": "sushmitha_123" ],
                     onView: self.view) { (response: ForgotPasswordModel) in
            self.forgotDetails = response
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtpViewController") as? OtpViewController {
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
