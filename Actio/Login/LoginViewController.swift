//
//  LoginViewController.swift
//  Actio
//
//  Created by senthil on 03/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    var iconClick = true
    let button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        passwordTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        self.loginButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        
       self.button.setImage(UIImage(named: "hidden-eye.png"), for: .normal)
       self.navigationController?.setNavigationBarHidden(true, animated: false)

        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(secureIconClickAction), for: .touchUpInside)
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func secureIconClickAction() {
        if(iconClick == true) {
            self.passwordTextField.isSecureTextEntry = false
            button.setImage(UIImage(named: "visibility-eye.png"), for: .normal)


        } else {
            self.passwordTextField.isSecureTextEntry = true
            self.button.setImage(UIImage(named: "hidden-eye.png"), for: .normal)


        }
        
        iconClick = !iconClick
    }
    @IBAction func signupButtonAction(_ sender: Any) {
        print("Signin Tapped!!")
        
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        
    }
    
    
}

