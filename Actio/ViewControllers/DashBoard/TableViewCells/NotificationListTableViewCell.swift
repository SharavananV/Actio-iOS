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
		
		var messageText: String = data.message?.msg ?? ""
		switch data.message?.type{
		case "friend_request":
			messageText += " from " + (data.fullName ?? "")

		case "accept_request", "parent_submit", "parent_reject", "parent_approve":
			messageText = (data.fullName ?? "") + " " + (data.message?.msg ?? "")

		default:
			break;
		}
		titleLabel.text = messageText
		
		if let image = data.message?.icon, let url = URL(string: baseImageUrl + image) {
			notificationImageView.load(url: url)
		} else {
			notificationImageView.image = nil
		}
		
		timeLabel.text = data.dateTime?.chatTime()
	}
}
