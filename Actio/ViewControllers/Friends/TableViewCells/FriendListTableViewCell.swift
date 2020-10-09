//
//  FriendListTableViewCell.swift
//  Actio
//
//  Created by senthil on 09/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol FriendListDelegate: class {
	func addFriendTapped(_ subscriberId: Int?, friendStatus: Int?)
}

class FriendListTableViewCell: UITableViewCell {
	
	static let reuseId = "FriendListTableViewCell"

	@IBOutlet var shadowContainer: UIView!
	@IBOutlet var profileImageView: UIImageView!
	@IBOutlet var actualNameLabel: UILabel!
	@IBOutlet var userNameLabel: UILabel!
	@IBOutlet var addFriendButton: UIButton!
	
	weak var delegate: FriendListDelegate?
	private var userDetails: User?
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let height = profileImageView.bounds.height
		profileImageView.layer.cornerRadius = height / 2
	}
	
	func configure(_ user: User?) {
		userNameLabel.text = user?.username
		actualNameLabel.text = user?.fullName
		profileImageView.image = UIImage(named: user?.profileImage ?? "userplaceholder")
		if let statusImage = user?.userFriendStatusImage {
			addFriendButton.setBackgroundImage(UIImage(named: statusImage), for: .normal)
		}
		
		self.userDetails = user
	}
	
	@IBAction func addFriendTapped(_ sender: Any) {
		delegate?.addFriendTapped(userDetails?.subscriberID, friendStatus: userDetails?.friendsStatus)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		shadowContainer.layer.cornerRadius = 10
		shadowContainer.layer.masksToBounds = true
		
		shadowContainer.backgroundColor = UIColor.white
		shadowContainer.layer.shadowColor = UIColor.lightGray.cgColor
		shadowContainer.layer.shadowOpacity = 0.8
		shadowContainer.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
		shadowContainer.layer.shadowRadius = 6.0
		shadowContainer.layer.masksToBounds = false
	}
}
