//
//  ContactListShareCell.swift
//  Actio
//
//  Created by senthil on 16/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ContactListShareCell: UITableViewCell {
	
	static let reuseId = "ContactListShareCell"

	@IBOutlet var profileImageView: UIImageView!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var selectedImageView: UIImageView!
	@IBOutlet var shadowContainer: UIView!
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let height = profileImageView.bounds.height
		profileImageView.layer.cornerRadius = height / 2
	}
	
	func configure(_ user: Friend?) {
		nameLabel.text = user?.username
		profileImageView.image = UIImage(named: user?.profileImage ?? "userplaceholder")
		selectedImageView.isHidden = user?.isSelected == false
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
