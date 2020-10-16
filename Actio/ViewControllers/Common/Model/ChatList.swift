//
//  ChatList.swift
//  Actio
//
//  Created by senthil on 16/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

struct ChatListResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	var status, logID: String?
	var friends: [Friend]?
}
