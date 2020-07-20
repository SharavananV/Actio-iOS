//
//  AcceptRejectRequestViewController.swift
//  Actio
//
//  Created by senthil on 13/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class AcceptRejectRequestViewController: UIViewController {

    @IBOutlet var arHeaderView: UIView!
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var rejectButton: UIButton!
    @IBOutlet var relationNameLabel: UILabel!
    @IBOutlet var relationTextfield: UITextField!
    @IBOutlet var arNameLabel: UILabel!
    var childID = String()
    var parentID = String()
    var urlString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rejectButton.layer.cornerRadius = 5.0
        self.rejectButton.clipsToBounds = true
        self.acceptButton.layer.cornerRadius = 5.0
        self.acceptButton.clipsToBounds = true
        relationTextfield.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        self.rejectButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.acceptButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.arHeaderView.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        apiParentInitCall(childID: "7265")


    }
    
    @IBAction func rejectButtonAction(_ sender: Any) {
    }
    
    @IBAction func acceptButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "showBeforeApproval", sender: sender)
    }
       func apiCall(childID: String,Mode: String,relationID: String,Status:String) {
             urlString = parentApprovalUrl
             AF.request(urlString, method: .post, parameters: ["childID": childID,"Status": Status,"Mode": Mode,"relationID": relationID],encoding:JSONEncoding.default, headers: nil).responseJSON {
                 response in
                 switch response.result {
                 case .success (let data):
                     print(response,"fgfgfgfsg")
                     
                 case .failure(_):
                     print("JSON")
                 }
                 
             }
             
         }
        
        
        func apiParentInitCall(childID: String) {
            let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
            "Content-Type": "application/json"]
            urlString = parentApprovalInitUrl
            AF.request(urlString, method: .post, parameters: ["childID": childID],encoding:JSONEncoding.default, headers: headers).responseJSON {
                response in
                switch response.result {
                case .success (let data):
                    self.childID = childID

                    print(response,"fgfgfgfsg")
                    
                case .failure(_):
                    print("JSON")
                }
                
            }
            
        }
        
    }
