//
//  EventDetailModel.swift
//  Actio
//
//  Created by senthil on 30/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - EventDetailResponse
struct EventDetailResponse: ResponseType {
	let errors: [ActioError]?
	var status: String?
	let event: EventDetail?
}

// MARK: - Event Detail
struct EventDetail: Codable {
	let id: Int
	let eventName, eventDescription, eventFee, eventBirdFee: String?
	let noOfTeam, minMemberPerTeam, maxMemberPerTeam, minAge: Int?
	let maxAge, minAgeGroupID, maxAgeGroupID: Int?
	let eventRegistrationEndDate: String?
	let sportsID, playerTypeID: Int?
	let playerType: String?
	let isEventOpen: Int?
	let eventEarlyBirdEndDate: String?
	let eventDate, type, eventLogo: String?
	let eventBanner: [String]?
	
	enum CodingKeys: String, CodingKey {
		case id
		case eventName = "event_name"
		case eventDescription = "description"
		case eventFee = "event_fee"
		case eventBirdFee = "event_bird_fee"
		case noOfTeam = "no_of_team"
		case minMemberPerTeam = "min_member_per_team"
		case maxMemberPerTeam = "max_member_per_team"
		case minAge = "min_age"
		case maxAge = "max_age"
		case minAgeGroupID = "min_age_group_id"
		case maxAgeGroupID = "max_age_group_id"
		case eventRegistrationEndDate = "event_registration_end_date"
		case sportsID = "sports_id"
		case playerTypeID = "player_type_id"
		case playerType = "player_type"
		case isEventOpen = "is_event_open"
		case eventEarlyBirdEndDate = "event_early_bird_end_date"
		case eventDate = "event_date"
		case type
		case eventLogo = "event_logo"
		case eventBanner = "event_banner"
	}
}
