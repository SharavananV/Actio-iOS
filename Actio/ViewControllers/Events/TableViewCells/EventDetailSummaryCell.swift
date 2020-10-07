//
//  EventDetailSummaryCell.swift
//  Actio
//
//  Created by senthil on 07/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EventDetailSummaryCell: UITableViewCell {
	
	static let reuseId = "EventDetailSummaryCell"

	@IBOutlet var eventIdLabel: UILabel!
	@IBOutlet var tournamentNameLabel: UILabel!
	@IBOutlet var eventNameLabel: UILabel!
	@IBOutlet var categoryLabel: UILabel!
	@IBOutlet var sportLabel: UILabel!
	@IBOutlet var eventFeeLabel: UILabel!
	@IBOutlet var discountLabel: UILabel!
	@IBOutlet var registrationDateLabel: UILabel!
	
	func configure(_ data: ViewStatus) {
		eventIdLabel.text = String(data.eventID ?? 0)
		tournamentNameLabel.text = data.tournamentName
		eventNameLabel.text = data.eventName
		categoryLabel.text = data.categoryName
		sportLabel.text = data.sportsName
		eventFeeLabel.text = data.amount
		discountLabel.text = data.birdDiscount
		registrationDateLabel.text = (data.rStartDate?.toDate?.dateFormatWithSuffix() ?? "") + " - " + (data.rEndDate?.toDate?.dateFormatWithSuffix() ?? "")
	}
}
