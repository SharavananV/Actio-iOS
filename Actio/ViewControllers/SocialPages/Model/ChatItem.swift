//
//  ChatItem.swift
//  Actio
//
//  Created by senthil on 12/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import MessageKit

class ChatItem {
	var senderId, senderName: String?
	var message, time, refId, type, imageUrl, position: String?
	var fromId, toId, status: String?
		
	init(_ data: [String: Any]) {
		self.message = data["msg"] as? String
		self.time = data["date"] as? String
		self.refId = data["refID"] as? String
		self.type = data["type"] as? String
		self.imageUrl = data["imgURL"] as? String
		self.position = data["position"] as? String
		self.status = data["status"] as? String
		self.fromId = data["fromID"] as? String
		self.toId = data["toID"] as? String
	}
	
	func convertIntoMessage() -> ChatMessage {
		let sender = Sender(senderId: fromId ?? "0", displayName: senderName ?? "")
		
		if type == "image", let url = URL(string: socketUrl+"/"+(imageUrl ?? "")), let placeHolder = UIImage(named: "placeholder") {
			let media = ChatPhoto(url: url, image: nil, placeholderImage: placeHolder, size: CGSize(width: 300, height: 300))
			return ChatMessage(sender: sender, messageId: "", sentDate: time?.toDate ?? Date(), kind: .photo(media), status: Int(status ?? "0"), position: Int(position ?? "0"))
		}
		else {
			return ChatMessage(sender: sender, messageId: "", sentDate: time?.toDate ?? Date(), kind: .text(self.message ?? ""), status: Int(status ?? "0"), position: Int(position ?? "0"))
		}
	}
}
