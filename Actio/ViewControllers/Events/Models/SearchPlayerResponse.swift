//
//  SearchPlayerResponse.swift
//  Actio
//
//  Created by senthil on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - SearchPlayerResponse
struct SearchPlayerResponse: ResponseType {
	let errors: [ActioError]?
	var status: String?
	var search: [SearchUserModel]?
}

// MARK: - Search
struct SearchUserModel: Codable {
	var subscriberID: Int?
	var subscriberDisplayID, fullName, dob: String?
	var age: Int?
	var ageAllow, isdCode, mobileNumber, emailID: String?
	var username: String?
	var gender: Int?
	var genderAllow: String?
	
	enum CodingKeys: String, CodingKey {
		case subscriberID = "subscriber_id"
		case subscriberDisplayID = "subscriber_display_id"
		case fullName = "full_name"
		case dob, age
		case ageAllow = "age_allow"
		case isdCode = "isd_code"
		case mobileNumber = "mobile_number"
		case emailID = "email_id"
		case username, gender
		case genderAllow = "gender_allow"
	}
}
