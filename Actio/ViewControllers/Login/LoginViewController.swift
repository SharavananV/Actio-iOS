//
//  LoginViewController.swift
//  Actio
//
//  Created by senthil on 03/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift



class LoginViewController: UIViewController {
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    var iconClick = true
    let button = UIButton(type: .custom)
    var urlString = String()
    var userNameString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userNameTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        passwordTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        self.loginButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        self.button.setImage(UIImage(named: "hidden-eye.png"), for: .normal)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(secureIconClickAction), for: .touchUpInside)
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        
        self.loginButton.layer.cornerRadius = 5.0
        self.loginButton.clipsToBounds = true
        
        //FIXME: - Status bar color
        
        let view: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.height))
        
        view.backgroundColor = AppColor.OrangeColor()
        
        self.view.addSubview(view)
        
        
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        
        apiCall(username: userNameTextField.text!, password: passwordTextField.text!,Mode: "3", deviceToken: UDHelper.getDeviceToken())
        
    }
    
    func apiCall(username: String,password: String,Mode: String,deviceToken:String) {
        urlString = loginUrl
        AF.request(urlString, method: .post, parameters: ["username": username,"password": password,"Mode": Mode,"deviceToken": deviceToken],encoding:JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success (let data):
                print(response,"fgfgfgfsg")
                
                if let resultDict = data as? [String: Any], let successText = resultDict["status"] as? String, successText == "200"{
                    
                    if (resultDict["userStatus"] as! String) == "1" {
                        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeAlertViewController") as? WelcomeAlertViewController {
                            self.userNameString = resultDict["fullName"] as! String
                            controller.loggedUserName = self.userNameString
                            
                            controller.modalPresentationStyle = .fullScreen
                            
                            self.present(controller, animated: false, completion: nil)
                        }
                        
                    }
                    
                    UDHelper.setAuthToken(resultDict["token"] as! String)
                    UDHelper.setUserId(resultDict["subscriberID"] as! String)
                    UDHelper.setUserLoggedIn(true)
                    self.navigateBasedOnStatus(resultDict["userStatus"] as! String)
                }
                else if let resultDict = data as? [String: Any], let invalidText = resultDict["msg"] as? String {
                    self.view.makeToast(invalidText)
                    
                }
                else {
                    let resultDict = data as? [String: Any]
                    if let status = resultDict!["status"] as? String, status == "422", let errors = resultDict!["errors"] as? [[String: Any]] {
                        if let firstError = errors.first, let msg = firstError["msg"] as? String {
                            self.view.makeToast(msg)
                            
                        }
                        
                    }
                }
                
            case .failure(_):
                print("JSON")
            }
            
        }
        
    }
    
    private func navigateBasedOnStatus(_ status: String) {
        switch status {
        case "1", "7", "8", "9":
            self.performSegue(withIdentifier: "showDashboard", sender: self)
            break
        case "5","6":
            self.performSegue(withIdentifier: "showEnterParentID", sender: self)
        case "3","4":
            self.performSegue(withIdentifier: "showOTP", sender: self)
        default:
            self.performSegue(withIdentifier: "LoginPage", sender: self)
        }
    }
    
    
}
extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

