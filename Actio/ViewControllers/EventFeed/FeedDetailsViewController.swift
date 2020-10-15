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
	private let service = DependencyProvider.shared.networkService
	var feedId: Int?
    var feedDetail: FeedDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
		if feedDetail != nil {
			self.refreshDisplay()
		} else {
			feedDetailCall()
		}
    }

	func feedDetailCall() {
		service.post(feedListUrl, parameters: ["feedID": feedId ?? 0, "search": ""], onView: view) { (response: EventFeedResponse) in
			guard let detail = response.list else { return }
			
			switch detail {
			case .list(_):
				break
			case .detail(let detail):
				self.feedDetail = detail
			}
			
			self.refreshDisplay()
		}
	}
	
	func refreshDisplay() {
		if let feedDetails = self.feedDetail {
			self.feedDescriptionLabel.text = feedDetails.listDescription
			self.feedNameLabel.text = feedDetails.fullName
			if feedDetails.images != nil {
				if let imagePath = URL(string:  baseImageUrl + feedDetails.images!) {
					self.feedImageView.load(url: imagePath)
				}
			}
		}
	}
}
