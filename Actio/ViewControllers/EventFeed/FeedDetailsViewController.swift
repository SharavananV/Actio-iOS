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
    var feedDetail: FeedDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let feedDetails = self.feedDetail {
            self.feedDescriptionLabel.text = feedDetails.listDescription
            self.feedNameLabel.text = feedDetails.fullName
            if feedDetails.images != nil {
                if let imagePath = URL(string:  baseUrl + feedDetails.images!) {
                    self.feedImageView.load(url: imagePath)
                }
            }
        }
    }

}
