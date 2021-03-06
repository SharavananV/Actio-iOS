//
//  AcceptRejectRequestViewController.swift
//  Actio
//
//  Created by senthil on 13/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class AcceptRejectRequestViewController: UIViewController {
    
    @IBOutlet var arHeaderView: UIView!
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var rejectButton: UIButton!
    @IBOutlet var relationNameLabel: UILabel!
    @IBOutlet var relationTextfield: UITextField!
    @IBOutlet var arNameLabel: UILabel!
    
    var childID = String()
    var parentID = String()
    var childNameString = String()
    var childDobString = String()
    var childUserStatus = String()
    var Mode = Int()
    var relationID = String()
    var addRelationArray = [String]()
	private let service = DependencyProvider.shared.networkService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        relationTextfield.inputView = pickerView
        changeNavigationBar()

        let view: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.height))
        view.backgroundColor = AppColor.OrangeColor()
        self.view.addSubview(view)
        
        self.rejectButton.layer.cornerRadius = 5.0
        self.rejectButton.clipsToBounds = true
        self.acceptButton.layer.cornerRadius = 5.0
        self.acceptButton.clipsToBounds = true
        
        self.rejectButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.acceptButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.arHeaderView.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        addRelationArray = []
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.relationTextfield.frame.height - 1, width: self.relationTextfield.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.black.cgColor
        relationTextfield.borderStyle = UITextField.BorderStyle.none
        relationTextfield.layer.addSublayer(bottomLine)
		
		apiParentInitCall(childID: childID)
    }
    
    @IBAction func rejectButtonAction(_ sender: Any) {
        apiCall(childID: self.childID, Mode: self.Mode, relationID: self.relationID, Status: 2)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func acceptButtonAction(_ sender: Any) {
        apiCall(childID: self.childID, Mode: self.Mode, relationID: self.relationID, Status: 1)
    }
	
    func apiCall(childID: String,Mode: Int,relationID: String,Status:Int) {
        service.post(parentApprovalUrl, parameters: ["childID": childID,"Status": Status,"Mode": self.Mode,"relationID": relationID], onView: view) { _ in
			self.dismiss(animated: false, completion: nil)
		}
    }
    
    func apiParentInitCall(childID: String) {
		service.post(parentApprovalInitUrl, parameters: ["childID": childID], onView: view) { resultDict in
			self.childID = childID
			let val = resultDict["relation"] as? NSArray
			for data in val! {
				self.addRelationArray.append((data as AnyObject).value(forKey: "bond") as? String ?? "")
			}
			
			if ((resultDict["name"] as? String) != nil) {
				self.childNameString = (resultDict["name"] as? String)!
				
			}
			if ((resultDict["dob"] as? String) != nil) {
				self.childDobString = (resultDict["dob"] as? String)!
				
			}
			if ((resultDict["childuserStatus"] as? String) != nil) {
				self.childUserStatus = (resultDict["childuserStatus"] as? String)!
				
			}
			let parentNameNumberAttrs1 = [NSAttributedString.Key.font: AppFont.PoppinsSemiBold(size: 16), NSAttributedString.Key.foregroundColor : AppColor.PurpleColor()]
			let parentNameNumberAttributedString1 = NSMutableAttributedString(string:self.childNameString + ", "+self.childDobString, attributes:parentNameNumberAttrs1 as [NSAttributedString.Key : Any])
			
			let parentNameNumberAttributedString2 = NSMutableAttributedString(string: " has requested to create a subscription under his name using your mobile number. Please Accept or Reject the request ", attributes:parentNameNumberAttrs1 as [NSAttributedString.Key : Any])
			
			parentNameNumberAttributedString1.append(parentNameNumberAttributedString2)
			self.arNameLabel.attributedText = parentNameNumberAttributedString1
			self.relationNameLabel.text = self.childNameString
			
			if self.childUserStatus == "7"{
				self.Mode = 1
			} else if self.childUserStatus == "8" {
				self.Mode = 2
			}
		}
    }
}

extension AcceptRejectRequestViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return addRelationArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "i am " + "" + addRelationArray[row] + "" + " of "
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.relationTextfield.text = "i am " + "" + addRelationArray[row] + "" + " of "
        if addRelationArray[row] == "Father" {
            self.relationID = "1"
            
        }else if addRelationArray[row] == "Mother"   {
            self.relationID = "2"
            
        }
    }
}
