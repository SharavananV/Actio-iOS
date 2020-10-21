//
//  FindFriendModel.swift
//  Actio
//
//  Created by senthil on 09/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - FindFriendResponse

struct MyProfileResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	let status, logID: String?
	let profile: ProfileData?
	let find: [Friend]?
	let list: [Friend]?
}

struct FindFriendResponse: ResponseType {
    var errors: [ActioError]?
    var msg: String?
    let status, logID: String?
    let profile: Friend?
    let find: [Friend]?
    let list: [Friend]?
}

// MARK: - Profile
struct ProfileData: Codable {
	let profile: Friend?
	let list: [Friend]?
}



// MARK: - Find
class Friend: Codable {
	let subscriberID: Int?
	let subscriberDisplayID, fullName, username, emailID: String?
	let profileImage: String?
	var friendsStatus: Int?
	var isSelected: Bool = false
	
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
	
	func convertToConversation() -> Conversation {
		return Conversation(subscriberID: subscriberID, subscriberDisplayID: subscriberDisplayID, fullName: fullName, username: username, emailID: emailID, profileImage: profileImage, chatID: nil, message: nil, unseen: nil)
	}
}



struct FriendsListResponse: ResponseType {
    var errors: [ActioError]?
    var msg: String?
	let status, logID: String?
    let profile: Profile?
    let list: [Friend]?
    let eventAssociated: [EventAssociated]?

    enum CodingKeys: String, CodingKey {
        case status, logID, profile, list
        case eventAssociated = "event_associated"
    }
}

// MARK: - EventAssociated
struct EventAssociated: Codable {
    let id: Int?
    let eventName, eventLogo, eventStartDate, eventStartMonth: String?
    let eventStartYear, eventAddress: String?
    let status: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case eventName = "event_name"
        case eventLogo = "event_logo"
        case eventStartDate = "event_start_date"
        case eventStartMonth = "event_start_month"
        case eventStartYear = "event_start_year"
        case eventAddress = "event_address"
        case status
    }
}

// MARK: - Profile
struct Profile: Codable {
    let subscriberID: Int?
    let subscriberDisplayID, fullName, username, emailID: String?
    let mobileNumber, isdCode, userType, idType: String?
    let proofID, frontImage, backImage, gender: String?
    let dob, profileImage: String?
    let friendsStatus: Int?

    enum CodingKeys: String, CodingKey {
        case subscriberID = "subscriber_id"
        case subscriberDisplayID = "subscriber_display_id"
        case fullName = "full_name"
        case username
        case emailID = "email_id"
        case mobileNumber = "mobile_number"
        case isdCode = "isd_code"
        case userType = "user_type"
        case idType = "id_type"
        case proofID = "proof_id"
        case frontImage = "front_image"
        case backImage = "back_image"
        case gender, dob
        case profileImage = "profile_image"
        case friendsStatus = "friends_status"
    }
}



