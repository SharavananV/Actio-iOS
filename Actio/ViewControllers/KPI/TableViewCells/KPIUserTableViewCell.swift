//
//  KPIUserTableViewCell.swift
//  Actio
//
//  Created by KnilaDev on 11/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class KPIUserTableViewCell: UITableViewCell {
	
	static let reuseId = "KPIUserTableViewCell"

	@IBOutlet var shadowContainer: UIView!
	@IBOutlet var userImageView: UIImageView!
	@IBOutlet var usernameLabel: UILabel!
	@IBOutlet var statusImageView: UIImageView!
	@IBOutlet var statusTextLabel: UILabel!
	
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
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let height = userImageView.bounds.height
		userImageView.layer.cornerRadius = height / 2
	}
	
	func configure(_ user: PlayerKPIDetail?) {
		usernameLabel.text = user?.playerName
		statusTextLabel.text = user?.eventStatus.displayString
		
		if let imageUrlString = user?.profileImage, !imageUrlString.isEmpty, let imageUrl = URL(string: baseImageUrl + imageUrlString) {
			userImageView.load(url: imageUrl)
		} else {
			userImageView.image = UIImage(named: "userplaceholder")
		}
		
		if let statusImage = user?.eventStatus.statusImage {
			statusImageView.image = UIImage(named: statusImage)
		}
	}
}
