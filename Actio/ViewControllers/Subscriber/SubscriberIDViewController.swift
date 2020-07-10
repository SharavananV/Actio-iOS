//
//  SubscriberIDViewController.swift
//  Actio
//
//  Created by senthil on 10/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class SubscriberIDViewController: UIViewController ,UIScrollViewDelegate{

    @IBOutlet var headerView: UIView!
    @IBOutlet var subsScrollView: UIScrollView!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var subscriptionIDTextField: UITextField!
    @IBOutlet var subscriberIDLabel: UILabel!
    @IBOutlet var subscriberNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subsScrollView.delegate = self
        self.continueButton.layer.cornerRadius = 5.0
        self.continueButton.clipsToBounds = true
        subscriptionIDTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        self.continueButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.headerView.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        
        subsScrollView.contentOffset = CGPoint(x: 0,y: 190)

        //FIXME: - Status bar color
        
         let view: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.height))

         view.backgroundColor = AppColor.OrangeColor()

         self.view.addSubview(view)

    }
    

    @IBAction func continueButtonAction(_ sender: Any) {
    }
}
