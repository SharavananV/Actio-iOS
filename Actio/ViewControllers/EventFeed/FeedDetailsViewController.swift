//
//  FeedDetailsViewController.swift
//  Actio
//
//  Created by senthil on 28/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class FeedDetailsViewController: UIViewController {
    
    @IBOutlet var feedDescriptionLabel: UILabel!
    @IBOutlet var feedNameLabel: UILabel!
    @IBOutlet var feedImageView: UIImageView!
    var feedList: FeedDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let feedDetails = self.feedList {
            self.feedDescriptionLabel.text = feedDetails.listDescription
            self.feedNameLabel.text = feedDetails.fullName
            if let imagePath = URL(string:  baseUrl + feedDetails.profileImage) {
                self.feedImageView.load(url: imagePath)
            }
        }
    }

}
