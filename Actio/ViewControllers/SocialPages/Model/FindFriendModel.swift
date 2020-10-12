//
//  FindFriendModel.swift
//  Actio
//
//  Created by senthil on 09/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - FindFriendResponse
struct FindFriendResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	let status: String?
    let find: [User]?
    let profile: User?
}

// MARK: - Find
class User: Codable {
	let subscriberID: Int?
	let subscriberDisplayID, fullName, username, emailID: String?
	let profileImage: String?
	var friendsStatus: Int?
	
	enum CodingKeys: String, CodingKey {
		case subscriberID = "subscriber_id"
		case subscriberDisplayID = "subscriber_display_id"
		case fullName = "full_name"
		case username
		case emailID = "email_id"
		case profileImage = "profile_image"
		case friendsStatus = "friends_status"
	}
	
	var userFriendStatusImage: String {
		switch friendsStatus {
		case 0:
			return "user-plus"
		case 2:
			return "user-check"
		default:
			return "user-simple"
		}
	}
}
