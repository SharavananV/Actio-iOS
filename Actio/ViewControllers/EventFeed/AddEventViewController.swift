//
//  AddEventViewController.swift
//  Actio
//
//  Created by apple on 29/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class AddEventViewController: UIViewController {

    @IBOutlet weak var feedTypeTextField: UITextField!
    
    @IBOutlet weak var feedTitleTextField: UITextField!
    
    @IBOutlet weak var feedShortDescriptionTextField: UITextField!
    
    @IBOutlet weak var feedDescriptionTextView: UITextView!
    
    @IBOutlet weak var feedImageView: UIImageView!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    private var feedModel = AddFeedModel()
    
    private lazy var imagePicker = ActioImagePicker(presentationController: self, delegate: self)
    var captureImgName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedDescriptionTextView.text = "Enter Description"
        self.feedDescriptionTextView.textColor = UIColor.lightGray
        
        self.feedDescriptionTextView.layer.borderColor = AppColor.TextFieldBorderColor().cgColor
        self.feedDescriptionTextView.layer.borderWidth = 1
        self.feedDescriptionTextView.delegate = self
        feedImageView.layer.masksToBounds = true
        feedImageView.layer.borderWidth = 1.5
        feedImageView.layer.borderColor = AppColor.TextFieldBorderColor().cgColor
        self.addImageButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.addImageButton.layer.cornerRadius = 5.0
        self.addImageButton.clipsToBounds = true

        let rightButtonItem = UIBarButtonItem.init(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(addFeedButtonAction)
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    @objc func addFeedButtonAction(){
        feedApiCall()

    }
    @IBAction func addImageButtonAction(_ sender: Any) {
        imagePicker.present(from: self.view)
        
    }
    
    func feedApiCall() {
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                     "Content-type": "multipart/form-data",
                                     "Content-Disposition" : "form-data"]
        let params = ["title" : self.feedTitleTextField.text ?? "",
                      "shortDescription" : self.feedShortDescriptionTextField.text ?? "",
                      "description" : self.feedDescriptionTextView.text ?? "",
                      "isRemove":false,
                      "image" : self.feedImageView.image?.pngData() ?? Data(),
                      "categoryID":1
        ] as [String : Any]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            guard let imgData = self.feedImageView.image?.jpegData(compressionQuality: 1) else { return }
            multipartFormData.append(imgData, withName: "MediaFile", fileName: "\(self.captureImgName ?? "").jpg", mimeType: "image/jpeg")
            
        },to: feedUrl, usingThreshold: UInt64.init(),
        method: .post,
        headers: headers).response{ response in
            if(response.value != nil){
                do{
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        
                        if let resultDict = parsedData as? [String: Any], let successStatus = resultDict["status"] as? String, successStatus == "200" ,let successText = resultDict["msg"] as? String{
                            self.view.makeToast(successText)
                            
                            self.feedTypeTextField.text = nil
                            self.feedTitleTextField.text = nil
                            self.feedShortDescriptionTextField.text = nil
                            self.feedDescriptionTextView.text = nil
                            self.feedImageView.image = nil
                            
                            
                        }
                        else if let resultDict = parsedData as? [String: Any], let invalidText = resultDict["msg"] as? String{
                            self.view.makeToast(invalidText)
                        }
                    }
                }catch{
                    print(response.error ?? "")
                    self.view.makeToast("Please try again later")
                }
            }else{
                self.view.makeToast("Please try again later")
            }
        }
    }
    
}
extension AddEventViewController : UITextViewDelegate, ActioPickerDelegate {
    
    func didSelect(url: URL?, type: String) {
        if let filePath = url?.path, let image = UIImage(contentsOfFile: filePath), let fileName = url?.lastPathComponent {
            if let data = image.jpegData(compressionQuality: 0.8) {
                let fileUrl = getDocumentsDirectory().appendingPathComponent(fileName)
                try? data.write(to: fileUrl)
                self.captureImgName = fileUrl.lastPathComponent
                feedImageView.image = UIImage(contentsOfFile:fileUrl.path)
            }
        }

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Description"
            textView.textColor = UIColor.lightGray
        }
    }
}
