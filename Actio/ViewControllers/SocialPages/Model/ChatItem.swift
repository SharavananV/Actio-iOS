//
//  ChatItem.swift
//  Actio
//
//  Created by senthil on 12/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

class ChatItem {
	var message, time, refId, type, imageUrl, position: String?
	var status: Int?
	
	init(_ data: [String: Any]) {
		self.message = data["msg"] as? String
		self.time = data["date"] as? String
		self.refId = data["refID"] as? String
		self.type = data["type"] as? String
		self.imageUrl = data["imgURL"] as? String
		self.position = data["position"] as? String
		self.status = data["status"] as? Int
	}
}
