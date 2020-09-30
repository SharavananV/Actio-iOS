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
    
    private lazy var imagePicker = ImagePicker(presentationController: self, delegate: self)
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


        let rightButtonItem = UIBarButtonItem.init(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(addFeed)
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
        

    }
    @objc func addFeed(){
        feedApiCall()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.feedDescriptionTextView.text = "Enter Description"
        self.feedDescriptionTextView.textColor = UIColor.lightGray
        
    }
    
    
    @IBAction func addImageButtonAction(_ sender: Any) {
        imagePicker.present(from: self.view)
        
    }
    
    func feedApiCall() {
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                            "Content-Type": "application/json"]
        let params = ["title" : self.feedTitleTextField.text ?? "",
                      "shortDescription" : self.feedShortDescriptionTextField.text ?? "",
                      "description" : self.feedDescriptionTextView.text ?? "",
                      "isRemove":false,
                      "image" : self.feedImageView.image?.pngData() ?? Data(),
                      "categoryID":1
        ] as [String : Any]

            NetworkRouter.shared.request(feedUrl, method: .post, parameters:params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            ActioSpinner.shared.hide()

            guard let model = response.value else {
                print("🥶 Error on login: \(String(describing: response.error))")
                return
            }
            print("modelllllllll\(model)")

        }
    }

    

}
extension AddEventViewController : UITextViewDelegate,ImagePickerDelegate {
    
    func didSelect(url: URL?, type: String) {
        if let filePath = url?.path, let image = UIImage(contentsOfFile: filePath), let fileName = url?.lastPathComponent {
            if let data = image.jpegData(compressionQuality: 0.8) {
                let fileUrl = getDocumentsDirectory().appendingPathComponent(fileName)
                try? data.write(to: fileUrl)
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
