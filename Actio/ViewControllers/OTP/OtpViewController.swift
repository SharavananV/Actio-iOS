//
//  OtpViewController.swift
//  Actio
//
//  Created by senthil on 09/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift


class OtpViewController: UIViewController,VPMOTPViewDelegate {
    var stringOtp = String()
    var urlString = String()
    
    var countTimer:Timer!
    
    var counter = 30
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var resendButton: UIButton!
    @IBOutlet var otpTextView: VPMOTPView!
    @IBOutlet var headerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTextView.otpFieldsCount = 4
        otpTextView.otpFieldDefaultBorderColor = AppColor.textFieldBorder
        otpTextView.otpFieldEnteredBorderColor = AppColor.textFieldBorder
        otpTextView.otpFieldBorderWidth = 1
        otpTextView.delegate = self
        otpTextView.otpFieldDisplayType = .square
        otpTextView.otpFieldEntrySecureType = true
        otpTextView.initalizeUI()
        
        self.resendButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.headerView.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        
        self.headerImage.layer.cornerRadius = self.headerImage.frame.height/2
        self.headerImage.clipsToBounds = true
        
        self.resendButton.layer.cornerRadius = 5.0
        self.resendButton.clipsToBounds = true
        
        self.countTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        //FIXME: - Status bar color
        
        let view: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.height))
        
        view.backgroundColor = AppColor.OrangeColor()
        
        self.view.addSubview(view)
        
        
    }
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        self.stringOtp = otpString
        apiCall(otp: otpString)
    }
    
    func hasEnteredAllOTP(hasEntered: Bool) {}
    
    @IBAction func resendButtonAction(_ sender: Any) {
        apiCall(otp: stringOtp)
    }
    
    func apiCall(otp:String) {
        urlString = validateOTPUrl
        
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                     "Content-Type": "application/json"]
        AF.request(validateOTPUrl,method: .post,parameters: ["otp":otp],encoding: JSONEncoding.default,headers: headers).responseJSON {
            response in
            switch response.result {
            case .success (let data):
                if let resultDict = data as? [String: Any], let successText = resultDict["status"] as? String, successText == "200" {
                    if let dashController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") {
                        dashController.modalPresentationStyle = .fullScreen
                        self.present(dashController, animated: true, completion: nil)
                    }
                }
                else if let resultDict = data as? [String: Any], let invalidText = resultDict["msg"] as? String{
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
                
            case .failure(let error):
                self.view.makeToast(error.errorDescription ?? "")
            }
            
        }
    }
    
    @objc func updateCounter() {
        if counter > 0
        {
            self.resendButton.isEnabled = false
            resendButton.setTitle("Resend in \(counter)" + "s", for: .normal)
            counter -= 1
        }
        else
        {
            self.resendButton.isEnabled = true
            resendButton.setTitle("Resend", for: .normal)
            countTimer.invalidate()
        }
    }
}
