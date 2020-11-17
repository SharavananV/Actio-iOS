//
//  EditProfileViewController.swift
//  Actio
//
//  Created by apple on 20/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class EditProfileViewController: UIViewController, ActioPickerDelegate {
	
    enum TabIndex : Int {
        case infoTab = 0
        case myRoleTab = 1
    }
    
    @IBOutlet weak var profileSegmentControl: UISegmentedControl!
    @IBOutlet weak var editProfileImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
	private lazy var imagePicker = ActioImagePicker(presentationController: self, delegate: self)
	var currentViewController: UIViewController?
    var userDetails: Friend?
    
    lazy var MyRoleViewController : MyRoleViewController? = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyRoleViewController") as! MyRoleViewController
        return viewController
    }()
    
    private lazy var InfoViewController: InfoViewController = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        viewController.userDetails = self.userDetails
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        profileSegmentControl.selectedSegmentIndex = TabIndex.infoTab.rawValue
        displayCurrentTab(TabIndex.infoTab.rawValue)
        
		if let profileImage = userDetails?.profileImage, let url = URL(string: baseImageUrl + profileImage) {
			editProfileImage.load(url: url)
		}
        editProfileImage.layer.cornerRadius = editProfileImage.frame.height/2
        editProfileImage.clipsToBounds = true
    }
	
	@IBAction func uploadProfilePicture(_ sender: Any) {
		imagePicker.present(from: self.view)
	}
	
    @IBAction func segementedControlAction(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParent()
        
        displayCurrentTab(sender.selectedSegmentIndex)

    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.infoTab.rawValue :
            vc = InfoViewController
        case TabIndex.myRoleTab.rawValue :
            vc = MyRoleViewController
        default:
            return nil
        }
        
        return vc
    }

	func didSelect(url: URL?, type: String) {
		uploadProfileImage(imageUrl: url)
	}
	
	func didCaptureImage(_ image: UIImage) {
		uploadProfileImage(image: image)
	}
	
	// TODO: Move this call to the network router class
	func uploadProfileImage(image: UIImage? = nil, imageUrl: URL? = nil) {
		ActioSpinner.shared.show(on: self.view)
		
		let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
									 "Content-type": "multipart/form-data",
									 "Content-Disposition" : "form-data"]
		
		AF.upload(multipartFormData: { (multipartFormData) in
			if let imgData = image?.jpegData(compressionQuality: 1) {
				multipartFormData.append(imgData, withName: "displayPicture", fileName: "images.jpg", mimeType: "image/jpeg")
			}
			else if let imageUrl = imageUrl {
				do {
					let mediaData = try Data(contentsOf: imageUrl)
					
					multipartFormData.append(mediaData, withName: "displayPicture", fileName: imageUrl.lastPathComponent, mimeType: "image/*")
				}
				catch {
					print("Error when converting media to data")
				}
			}
			
		},to: profileImageUploadUrl, usingThreshold: UInt64.init(),
		method: .post,
		headers: headers).response{ [weak self] response in
			ActioSpinner.shared.hide()
			
			if(response.value != nil){
				do{
					if let jsonData = response.data{
						let parsedData = try JSONSerialization.jsonObject(with: jsonData) as? Dictionary<String, AnyObject>
						
						if let successStatus = parsedData?["status"] as? String, successStatus == "200" {
							if let imageUrl = parsedData?["profile_image"] as? String, let actualUrl = URL(string: baseImageUrl + imageUrl), let message = parsedData?["msg"] as? String {
								
								self?.editProfileImage.load(url: actualUrl)
								self?.view.makeToast(message)
							}
						}
						else if let json = parsedData, json["status"] as? String == "422", let errors = json["errors"] as? [[String: Any]], let message = errors.first?["msg"] as? String {
							self?.view.makeToast(message)
							
							return
						}
					}
				}catch{
					print(response.error ?? "")
					self?.view.makeToast("Please try again later")
				}
			}else{
				self?.view.makeToast("Please try again later")
			}
		}
	}
}
