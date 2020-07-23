//
//  SubscriberIDViewController.swift
//  Actio
//
//  Created by senthil on 10/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire
class SubscriberIDViewController: UIViewController ,UIScrollViewDelegate{
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var subsScrollView: UIScrollView!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var subscriptionIDTextField: UITextField!
    @IBOutlet var subscriberIDLabel: UILabel!
    @IBOutlet var subscriberNameLabel: UILabel!
    
    var urlString = String()
    var parentNameString = String()
    var parendIsdString = String()
    var parentMobileString = String()
    var currentUserStatus = String()
    var Mode = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.continueButton.layer.cornerRadius = 5.0
        self.continueButton.clipsToBounds = true
        subscriptionIDTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        self.continueButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.headerView.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        
        //FIXME: - Status bar color
        
        let view: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.height))
        
        view.backgroundColor = AppColor.OrangeColor()
        
        self.view.addSubview(view)
        
        apiCall(parentName: parentNameString, parentIsd: parendIsdString, parentMobile: parentMobileString, currentUserStatus: currentUserStatus)
        
        
        
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        if self.subscriptionIDTextField.text == "" {
            self.view.makeToast("SUBSCRIPTION ID Empty!!")
            
        } else {
            apiSubmitCall(parentID: self.subscriptionIDTextField.text!, Mode: Mode)
        }
    }
    
    
    func apiSubmitCall(parentID:String,Mode : Int) {
        urlString = parentIdUrl
        
        
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                     "Content-Type": "application/json"]
        AF.request(parentIdUrl,method: .post,parameters: ["parentID":parentID,"Mode":Mode],encoding: JSONEncoding.default,headers: headers).responseJSON {
            response in
            switch response.result {
            case .success (let data):
                print(data)
                if let resultDict = data as? [String: Any], let successText = resultDict["status"] as? String, successText == "200"{
                    if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BeforeApprovalViewController") as? BeforeApprovalViewController {
                        controller.parentName = self.parentNameString
                        controller.modalPresentationStyle = .fullScreen
                        
                        self.present(controller, animated: false, completion: nil)
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
                
                
            case .failure(_):
                print("error")
            }
            
        }
    }
    
    
    
    
    
    
    //UserStatusInfo - Api Call
    func apiCall(parentName:String,parentIsd:String,parentMobile:String,currentUserStatus:String) {
        urlString = userStatusUrl
        
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                     "Content-Type": "application/json"]
        AF.request(userStatusUrl,method: .post,parameters: ["parentName":parentName,"parentIsd":parentIsd,"parentMobile":parentMobile,"currentUserStatus":currentUserStatus],encoding: JSONEncoding.default,headers: headers).responseJSON {
            response in
            switch response.result {
            case .success (let data):
                print(response,"subscription")
                if let resultDict = data as? [String: Any], let successText = resultDict["status"] as? String, successText == "200"{
                    print(resultDict)
                    if ((resultDict["parentIsd"] as? String) != nil) {
                        self.parendIsdString = (resultDict["parentIsd"] as? String)!
                        
                    }
                    if ((resultDict["parentMobile"] as? String) != nil) {
                        self.parentMobileString = (resultDict["parentMobile"] as? String)!
                        
                    }
                    if ((resultDict["parentName"] as? String) != nil) {
                        self.parentNameString = (resultDict["parentName"] as? String)!
                        
                    }
                    self.currentUserStatus = (resultDict["currentUserStatus"] as? String)!
                    
                    
                    let parentNameNumberAttrs1 = [NSAttributedString.Key.font: AppFont.PoppinsSemiBold(size: 18), NSAttributedString.Key.foregroundColor : AppColor.PurpleColor()]
                    let parentNameNumberAttributedString1 = NSMutableAttributedString(string: "The mobile number "+self.parendIsdString+self.parentMobileString+" has ", attributes:parentNameNumberAttrs1 as [NSAttributedString.Key : Any])
                    
                    let parentNameNumberAttributedString2 = NSMutableAttributedString(string: " been used by our subscriber "+self.parentNameString, attributes:parentNameNumberAttrs1 as [NSAttributedString.Key : Any])
                    
                    parentNameNumberAttributedString1.append(parentNameNumberAttributedString2)
                    self.subscriberNameLabel.attributedText = parentNameNumberAttributedString1
                    
                    let parentNameAttrs1 = [NSAttributedString.Key.font: AppFont.PoppinsRegular(size: 16), NSAttributedString.Key.foregroundColor : AppColor.PurpleColor()]
                    let parentNameAttributedString1 = NSMutableAttributedString(string: "Please enter the Subscriber ID of "+self.parentNameString, attributes:parentNameAttrs1 as [NSAttributedString.Key : Any])
                    
                    let parentNameAttributedString2 = NSMutableAttributedString(string: " to obtain his authorization ", attributes:parentNameAttrs1 as [NSAttributedString.Key : Any])
                    
                    parentNameAttributedString1.append(parentNameAttributedString2)
                    self.subscriberIDLabel.attributedText = parentNameAttributedString1
                    
                    
                    if self.currentUserStatus == "5"{
                        self.Mode = 1
                    } else if self.currentUserStatus == "6" {
                        self.Mode = 2
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
                
                
            case .failure(_):
                print("error")
            }
            
        }
    }
    
    
}
