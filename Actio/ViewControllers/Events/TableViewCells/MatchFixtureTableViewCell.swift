//
//  MatchFixtureTableViewCell.swift
//  Actio
//
//  Created by KnilaDev on 12/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class MatchFixtureTableViewCell: UITableViewCell {
	
	static let reuseId = "MatchFixtureTableViewCell"

	@IBOutlet var containerView: UIView!
	@IBOutlet var fromLabel: UILabel!
	@IBOutlet var toLabel: UILabel!
	@IBOutlet var versusLabel: UILabel!
	@IBOutlet var venueLabel: UILabel!
	@IBOutlet var matchNameLabel: UILabel!
	@IBOutlet var remarksLabel: UILabel!
	
	func configure(_ details: Match?) {
		fromLabel.text = details?.from
		toLabel.text = details?.to
		versusLabel.text = (details?.competitor ?? "") + " vs " + (details?.opponent ?? "")
		venueLabel.text = details?.venueAssetName
		matchNameLabel.text = details?.matchName
		remarksLabel.text = details?.changeRemarks?.htmlToString
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		containerView.layer.cornerRadius = 10
		containerView.layer.masksToBounds = true
		
		containerView.layer.shadowColor = UIColor.lightGray.cgColor
		containerView.layer.shadowOpacity = 0.8
		containerView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
		containerView.layer.shadowRadius = 2.0
		containerView.layer.masksToBounds = false
	}
}
