//
//  ProfilePageViewController.swift
//  Actio
//
//  Created by senthil on 25/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {

    @IBOutlet var profileEmailLabel: UILabel!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
	
	var userDetails: User?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		profileEmailLabel.text = userDetails?.emailID
		profileNameLabel.text = userDetails?.fullName
		if let url = URL(string: userDetails?.profileImage ?? "") {
			profileImageView.load(url: url)
		}
    }
    
	@IBAction func chatAction(_ sender: Any) {
		
	}
}
