//
//  AddEventViewController.swift
//  Actio
//
//  Created by apple on 29/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class AddEditFeedViewController: UIViewController {

    @IBOutlet weak var feedTypeTextField: UITextField!
    
    @IBOutlet weak var feedTitleTextField: UITextField!
    
    @IBOutlet weak var feedShortDescriptionTextField: UITextField!
    
    @IBOutlet weak var feedDescriptionTextView: UITextView!
    
    @IBOutlet weak var feedImageView: UIImageView!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    var feedModel: FeedDetailModel?
    
    private lazy var imagePicker = ActioImagePicker(presentationController: self, delegate: self)
    var captureImgName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedDescriptionTextView.layer.borderColor = AppColor.TextFieldBorderColor().cgColor
        self.feedDescriptionTextView.layer.borderWidth = 1
        self.feedDescriptionTextView.delegate = self
        feedImageView.layer.masksToBounds = true
        feedImageView.layer.borderWidth = 1.5
        feedImageView.layer.borderColor = AppColor.TextFieldBorderColor().cgColor
        self.addImageButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.addImageButton.layer.cornerRadius = 5.0
        self.addImageButton.clipsToBounds = true
        
        if let feedDetail = self.feedModel {
            feedTitleTextField.text = feedDetail.title
            feedDescriptionTextView.text = feedDetail.listDescription
            feedShortDescriptionTextField.text = feedDetail.shortDescription
            
            if let image = feedDetail.images, let url = URL(string: baseUrl + image) {
                feedImageView.load(url: url)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        var params = ["title" : self.feedTitleTextField.text ?? "",
                      "shortDescription" : self.feedShortDescriptionTextField.text ?? "",
                      "description" : self.feedDescriptionTextView.text ?? "",
                      "isRemove":false,
                      "categoryID":1
        ] as [String : Any]
        
        if let feedId = feedModel?.feedID {
            params["feedID"] = feedId
        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            guard let imgData = self.feedImageView.image?.jpegData(compressionQuality: 1) else { return }
            multipartFormData.append(imgData, withName: "image", fileName: "\(self.captureImgName ?? "").jpg", mimeType: "image/jpeg")
            
        },to: feedUrl, usingThreshold: UInt64.init(),
        method: .post,
        headers: headers).response{ response in
            if(response.value != nil){
                do{
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        
                        if let successStatus = parsedData["status"] as? String, successStatus == "200" ,let successText = parsedData["msg"] as? String{
                            self.view.makeToast(successText)
                            
                            self.feedTypeTextField.text = nil
                            self.feedTitleTextField.text = nil
                            self.feedShortDescriptionTextField.text = nil
                            self.feedDescriptionTextView.text = nil
                            self.feedImageView.image = nil
                            
                            
                        }
                        else if let invalidText = parsedData["msg"] as? String {
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
extension AddEditFeedViewController : UITextViewDelegate, ActioPickerDelegate {
    
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
    
    func didCaptureImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let fileUrl = getDocumentsDirectory().appendingPathComponent("images.jpeg")
            try? data.write(to: fileUrl)
            self.captureImgName = fileUrl.lastPathComponent
            feedImageView.image = UIImage(contentsOfFile:fileUrl.path)
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
