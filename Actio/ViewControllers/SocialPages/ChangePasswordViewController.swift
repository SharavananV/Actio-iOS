//
//  ChangePasswordViewController.swift
//  Actio
//
//  Created by apple on 16/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    var iconClick = true
    let oldSecureClickButton = UIButton(type: .custom)
    let newSecureClickButton = UIButton(type: .custom)
    let confirmSecureClickButton = UIButton(type: .custom)
    private let service = DependencyProvider.shared.networkService
    var updatePasswordDetails: UpdatePasswordModel?
    var userName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        oldPasswordTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        newPasswordTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        confirmPasswordTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        self.updateButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])

        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        self.updateButton.layer.cornerRadius = 5.0
        self.updateButton.clipsToBounds = true


        self.oldSecureClickButton.setImage(UIImage(named: "hidden-eye.png"), for: .normal)
        self.newSecureClickButton.setImage(UIImage(named: "hidden-eye.png"), for: .normal)
        self.confirmSecureClickButton.setImage(UIImage(named: "hidden-eye.png"), for: .normal)
        
        oldSecureClickButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        oldSecureClickButton.frame = CGRect(x: CGFloat(self.oldPasswordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        oldSecureClickButton.addTarget(self, action: #selector(secureIconClickActionOldPassword), for: .touchUpInside)

        
        newSecureClickButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        newSecureClickButton.frame = CGRect(x: CGFloat(self.newPasswordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        newSecureClickButton.addTarget(self, action: #selector(secureIconClickActionNewPassword), for: .touchUpInside)
        confirmSecureClickButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)

        confirmSecureClickButton.frame = CGRect(x: CGFloat(self.confirmPasswordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        confirmSecureClickButton.addTarget(self, action: #selector(secureIconClickActionConfirmPassword), for: .touchUpInside)
        oldPasswordTextField.rightView = oldSecureClickButton
        oldPasswordTextField.rightViewMode = .always
        newPasswordTextField.rightView = newSecureClickButton
        newPasswordTextField.rightViewMode = .always
        confirmPasswordTextField.rightView = confirmSecureClickButton
        confirmPasswordTextField.rightViewMode = .always

    }
    private func changePasswordDetails() {
        service.post(updatePasswordUrl,
                     parameters: ["username": userName ?? "" ,"password1":self.newPasswordTextField.text ?? "","password2":self.confirmPasswordTextField.text ?? ""],
                     onView: self.view) { (response: UpdatePasswordModel) in
            self.updatePasswordDetails = response
            self.navigationController?.popViewController(animated: true)
            self.view.makeToast("Password Updated Successfully")
        }
    }

    
    @objc func secureIconClickActionOldPassword() {
        if(iconClick == true) {
            self.oldPasswordTextField.isSecureTextEntry = false
            oldSecureClickButton.setImage(UIImage(named: "visibility-eye.png"), for: .normal)
        } else {
            self.oldPasswordTextField.isSecureTextEntry = true
            self.oldSecureClickButton.setImage(UIImage(named: "hidden-eye.png"), for: .normal)
        }
        iconClick = !iconClick
    }
    @objc func secureIconClickActionNewPassword() {
        if(iconClick == true) {
            self.newPasswordTextField.isSecureTextEntry = false
            newSecureClickButton.setImage(UIImage(named: "visibility-eye.png"), for: .normal)
        } else {
            self.newPasswordTextField.isSecureTextEntry = true
            self.newSecureClickButton.setImage(UIImage(named: "hidden-eye.png"), for: .normal)
        }
        iconClick = !iconClick
    }
    @objc func secureIconClickActionConfirmPassword() {
        if(iconClick == true) {
            self.confirmPasswordTextField.isSecureTextEntry = false
            confirmSecureClickButton.setImage(UIImage(named: "visibility-eye.png"), for: .normal)
        } else {
            self.confirmPasswordTextField.isSecureTextEntry = true
            self.confirmSecureClickButton.setImage(UIImage(named: "hidden-eye.png"), for: .normal)
        }
        iconClick = !iconClick
    }

    
    @IBAction func updateButtonAction(_ sender: Any) {
        changePasswordDetails()
    }
    
}
extension ChangePasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

