//
//  NotificationListTableViewCell.swift
//  Actio
//
//  Created by senthil on 01/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class NotificationListTableViewCell: UITableViewCell {

	static let reuseId = "NotificationListTableViewCell"
	
	@IBOutlet var timeLabel: UILabel!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var notificationImageView: UIImageView!
	
	func configure(_ data: NotificationModel) {
		self.contentView.backgroundColor = data.seenStatus == 0 ? #colorLiteral(red: 0.9882352941, green: 0.9411764706, blue: 0.9176470588, alpha: 1) : .white
		
		titleLabel.text = data.message?.msg
		
		if let image = data.message?.icon, let url = URL(string: baseImageUrl + image) {
			notificationImageView.load(url: url)
		} else {
			notificationImageView.image = nil
		}
		
		let feedDateFormatter = DateFormatter()
		feedDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		if let createdDate = feedDateFormatter.date(from: data.dateTime ?? ""), Calendar.current.isDateInToday(createdDate) {
			let timeDiff = abs(createdDate.timeIntervalSince(Date()))
			timeLabel.text = timeDiff.displayString + " ago"
		} else {
			timeLabel.text = data.dateTime
		}
	}
}
