//
//  ActioKPITableViewCell.swift
//  Actio
//
//  Created by KnilaDev on 11/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ActioKPITableViewCell: UITableViewCell {
	
	static let reuseId = "ActioKPITableViewCell"
	
	@IBOutlet var actioImageView: UIImageView!
	@IBOutlet var statusLabel: PaddingLabel!
	@IBOutlet var eventNameLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var venueLabel: UILabel!
	
	func configure(_ model: ActioEvent?) {
		if let imageUrlString = model?.eventLogo, let imageUrl = URL(string: baseImageUrl + imageUrlString) {
			actioImageView.load(url: imageUrl)
		}
		
		statusLabel.text = model?.eventStatus.displayString
		statusLabel.backgroundColor = model?.eventStatus.statusColor
		eventNameLabel.text = model?.tournamentName
		venueLabel.text = model?.eventVenue
		statusLabel.isHidden = model?.eventStatus == .pending
		
		if let startDate = model?.eventStartDate, let endDate = model?.eventEndDate {
			dateLabel.text = startDate + " - " + endDate
		}
	}
}
