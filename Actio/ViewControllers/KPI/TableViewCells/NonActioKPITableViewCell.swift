//
//  NonActioKPITableViewCell.swift
//  Actio
//
//  Created by KnilaDev on 11/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class NonActioKPITableViewCell: UITableViewCell {
	
	static let reuseId = "NonActioKPITableViewCell"
	
	@IBOutlet var eventNameLabel: UILabel!
	@IBOutlet var categoryLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var venueLabel: UILabel!
	@IBOutlet var statusLabel: PaddingLabel!
	
	func configure(_ model: NonActioEvent?) {
		eventNameLabel.text = model?.tournamentName
		categoryLabel.text = model?.eventName
		venueLabel.text = model?.eventVenue
		statusLabel.text = model?.eventStatus.displayString
		statusLabel.backgroundColor = model?.eventStatus.statusColor
		statusLabel.textColor = .white
		statusLabel.layer.cornerRadius = 10.0
		statusLabel.layer.borderWidth = 1.0
		statusLabel.clipsToBounds = true
		statusLabel.layer.borderColor = UIColor.black.cgColor
		
		if let startDate = model?.eventStartDate, let endDate = model?.eventEndDate {
			dateLabel.text = startDate + " - " + endDate
		}
	}
}
