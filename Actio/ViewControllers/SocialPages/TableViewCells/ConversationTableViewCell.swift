//
//  ConversationTableViewCell.swift
//  Actio
//
//  Created by senthil on 14/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
	
	static let reuseId = "ConversationTableViewCell"

	@IBOutlet var userImageView: UIImageView!
	@IBOutlet var senderNameLabel: UILabel!
	@IBOutlet var messagePeekLabel: UILabel!
	@IBOutlet var timeLabel: UILabel!
	@IBOutlet var unreadCountLabel: PaddingLabel!
	
	func configure(_ data: Conversation) {
		if let profileImage = data.profileImage, let url = URL(string: baseImageUrl + profileImage) {
			self.userImageView.load(url: url)
		}
		
		senderNameLabel.text = data.fullName
		timeLabel.text = data.message?.date?.chatTime()
		unreadCountLabel.text = data.unseen
		
		if data.message?.type == "image" {
			messagePeekLabel.text = "Photo"
		} else {
			messagePeekLabel.text = data.message?.msg
		}
		
		if data.unseen == "0" {
			unreadCountLabel.isHidden = true
		}
		
		self.contentView.backgroundColor = data.unseen == "0" ? .white : #colorLiteral(red: 0.9882352941, green: 0.9411764706, blue: 0.9176470588, alpha: 1)
	}
}
