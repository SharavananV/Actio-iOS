//
//  EventListTableViewCell.swift
//  Actio
//
//  Created by senthil on 30/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EventListTableViewCell: UITableViewCell {
	static let reuseId = "EventListTableViewCell"
	
    @IBOutlet var shadowContainer: UIView!
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var eventStatusLabel: PaddingLabel!
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var gameTypeLabel: UILabel!
    @IBOutlet var gameCategoryLabel: UILabel!
    @IBOutlet var gameTimeLabel: UILabel!
    @IBOutlet var venueLabel: UILabel!
    
	func configure(_ event: Event) {
		if let eventLogo = event.eventLogo, let imageUrl = URL(string: baseUrl + eventLogo) {
			self.eventImageView.load(url: imageUrl)
		}
		
		let status = Event.Status.init(rawValue: event.isRegistrationOpen)
		eventStatusLabel.text = status?.displayString
		eventStatusLabel.backgroundColor = status?.backgroundColor
		eventTitleLabel.text = event.eventName
		gameTypeLabel.text = event.eventType
		gameCategoryLabel.text = event.eventCategory
		venueLabel.text = event.eventAddress
		
		if let startDate = event.eventStartDate, let endDate = event.eventEndDate {
			gameTimeLabel.text = startDate + " - " + endDate
		} else if let startDate = event.eventStartDate {
			gameTimeLabel.text = startDate
		} else {
			gameTimeLabel.text = event.eventEndDate ?? ""
		}
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
