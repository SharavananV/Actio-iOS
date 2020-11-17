//
//  OtpViewController.swift
//  Actio
//
//  Created by senthil on 09/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class OtpViewController: UIViewController,VPMOTPViewDelegate {
    var stringOtp = String()
    var urlString = String()
    var countTimer:Timer!
    var counter = 60
    var fromController: OtpStatus = .login
    var username: String?

    let service = DependencyProvider.shared.networkService
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var resendButton: UIButton!
    @IBOutlet var otpTextView: VPMOTPView!
    @IBOutlet var headerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTextView.otpFieldsCount = 4
        otpTextView.otpFieldDefaultBorderColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)
        otpTextView.otpFieldEnteredBorderColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)
        otpTextView.otpFieldBorderWidth = 1
        otpTextView.delegate = self
        otpTextView.otpFieldDisplayType = .square
        otpTextView.otpFieldEntrySecureType = true
        otpTextView.initalizeUI()
        
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        self.stringOtp = otpString
        validateApiCall(otp: otpString)
    }
    
    func hasEnteredAllOTP(hasEntered: Bool) {}
    
    @IBAction func resendButtonAction(_ sender: Any) {
        apiSendOtpCall(otp: stringOtp)
    }
    
    func validateApiCall(otp:String) {
        let url = fromController == .login ? validateOTPUrl : validateForgotPasswordUrl
        
        var parameters = ["otp": otp]
        if fromController == .forgotPassword {
            parameters["username"] = (username ?? "")
        }
        
		service.post(url, parameters: parameters, onView: view) { _ in
			if url == validateOTPUrl {
				if let dashController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") {
					dashController.modalPresentationStyle = .fullScreen
					self.present(dashController, animated: true, completion: nil)
				}
			} else {
				if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController {
					vc.userName = self.username
					self.navigationController?.pushViewController(vc, animated: true)
				}
			}
		}
    }
	
    func apiSendOtpCall(otp:String) {
        let url = fromController == .login ? validateOTPUrl : forgotPasswordResendOtpUrl
		
        var parameters = ["otp": otp]
        if fromController == .forgotPassword {
            parameters["username"] = (username ?? "")
        }
		
		service.post(url, parameters: parameters, onView: view) { _ in
			self.view.makeToast("OTP sent successfully")
		}
    }

    
    @objc func updateCounter() {
        if counter > 0
        {
            self.resendButton.isEnabled = false
            resendButton.setTitle("\(counter)", for: .normal)
            resendButton.backgroundColor = UIColor.white
            resendButton.setTitleColor(UIColor(hex: "#505050"), for: .normal)
            counter -= 1
        }
        else
        {
            self.resendButton.isEnabled = true
            self.resendButton.applyGradient(colours: [AppColor.ButtonGreyColor(),AppColor.ButtonGreyColor()])
            resendButton.setTitleColor(UIColor(hex: "#7D7D7D"), for: .normal)
            resendButton.setTitle("RESEND OTP", for: .normal)
            countTimer.invalidate()
        }
    }
    
    enum OtpStatus {
        case login, forgotPassword
    }
}
