//
//  PlayerSummaryTableViewCell.swift
//  Actio
//
//  Created by senthil on 07/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class PlayerSummaryTableViewCell: UITableViewCell {

	static let reuseId = "PlayerSummaryTableViewCell"
	
	@IBOutlet var playerNameLabel: UILabel!
	@IBOutlet var genderLabel: UILabel!
	@IBOutlet var dobLabel: UILabel!
	@IBOutlet var mobileNumberLabel: UILabel!
	@IBOutlet var emailLabel: UILabel!
	@IBOutlet var gamePositionLabel: UILabel!
	
	func configure(_ player: PlayerSummary) {
		playerNameLabel.text = player.fullName
		genderLabel.text = player.gender
		dobLabel.text = player.dob
		mobileNumberLabel.text = String(player.mobileNumber ?? 0)
		emailLabel.text = player.emailID
		gamePositionLabel.text = player.position
	}
}
