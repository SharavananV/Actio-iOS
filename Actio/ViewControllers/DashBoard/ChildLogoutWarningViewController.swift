//
//  ChildLogoutWarningViewController.swift
//  Actio
//
//  Created by senthil on 23/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire
class ChildLogoutWarningViewController: UIViewController {
    let dependencyProvider = DependencyProvider.shared
    weak var delegate: LogoutDelegate?


    @IBOutlet var okButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var alertView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.okButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.cancelButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        
        self.okButton.layer.cornerRadius = 5.0
        self.okButton.clipsToBounds = true

        self.cancelButton.layer.cornerRadius = 5.0
        self.cancelButton.clipsToBounds = true
        
        self.alertView.layer.cornerRadius = 5.0
        self.alertView.clipsToBounds = true
        



    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)

    }
    @IBAction func okButtonAction(_ sender: Any) {
        self.dependencyProvider.registerDatasource.logout { (message) in
            UDHelper.resetUserStuff()

            self.view.makeToast(message)
            
            if message == "Logout Success" {
                if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false, completion: nil)
                }
            }

        }
        
    }
    func logout(completion: @escaping ((String) -> Void)) {
        
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                     "Content-Type": "application/json"]
        AF.request(logoutUrl,method: .post, parameters: ["Mode":"1", "deviceToken": UDHelper.getDeviceToken()], encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success (let data):
                if let resultDict = data as? [String: Any] {
                    if let status = resultDict["status"] as? String, status == "200", let message = resultDict["msg"] as? String {
                        UDHelper.resetUserStuff()
                        
                        completion(message)
                    }
                    else if let status = resultDict["status"] as? String, status == "422", let errors = resultDict["errors"] as? [[String: Any]] {
                        if let firstError = errors.first, let msg = firstError["msg"] as? String {
                            completion(msg)
                        }
                    }
                    else {
                        completion("Network error, couldn't logout")
                    }
                }
            case .failure(_):
                completion("Network error, couldn't logout")
            }
        }
        
    }

}
