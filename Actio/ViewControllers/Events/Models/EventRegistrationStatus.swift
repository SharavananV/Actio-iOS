//
//  EventRegistrationStatus.swift
//  Actio
//
//  Created by senthil on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - EventRegistrationStatus
struct EventRegistrationStatus: ResponseType {
	var status: String?
	var view: ViewStatus?
}

// MARK: - View
struct ViewStatus: Codable {
	var registrationID, logStatus, status, eventID: Int?
	var eventName: String?
	var tournamentID: Int?
	var tournamentName: String?
	var sportsID: Int?
	var sportsName: String?
	var categoryID: Int?
	var categoryName: String?
	var minAgeGroupID, maxAgeGroupID, minMemberPerTeam, maxMemberPerTeam: Int?
	var amount, birdDiscount, fRStartDate, fREndDate: String?
	var rStartDate, rEndDate, eventStartDate, eventEndDate: String?
	var fromTime, toTime, fromtime, totime: String?
	var registerByID: Int?
	var registerBy: String?
	var eventTypeID: Int?
	var registerAs: String?
	var playerTypeID: Int?
	var playerType: String?
	var ageGroupID: Int?
	var ageGroup, teamName, coachName, coachIsdCode: String?
	var coachMobileNumber: String?
	var coachEmailID: String?
	var cityID: Int?
	var cityName: String?
	var stateID: Int?
	var stateName: String?
	var countryID: Int?
	var countryName: String?
	var remarks: String?
	var subscriberAllowEdit: Int?
	var players: [PlayerSummary]?
	var allowReject: Int?
	
	enum CodingKeys: String, CodingKey {
		case registrationID = "registration_id"
		case logStatus = "log_status"
		case status
		case eventID = "event_id"
		case eventName = "event_name"
		case tournamentID = "tournament_id"
		case tournamentName = "tournament_name"
		case sportsID = "sports_id"
		case sportsName = "sports_name"
		case categoryID = "category_id"
		case categoryName = "category_name"
		case minAgeGroupID = "min_age_group_id"
		case maxAgeGroupID = "max_age_group_id"
		case minMemberPerTeam = "min_member_per_team"
		case maxMemberPerTeam = "max_member_per_team"
		case amount
		case birdDiscount = "bird_discount"
		case fRStartDate = "f_r_start_date"
		case fREndDate = "f_r_end_date"
		case rStartDate = "r_start_date"
		case rEndDate = "r_end_date"
		case eventStartDate = "event_start_date"
		case eventEndDate = "event_end_date"
		case fromTime = "from_time"
		case toTime = "to_time"
		case fromtime, totime
		case registerByID = "register_by_id"
		case registerBy = "register_by"
		case eventTypeID = "event_type_id"
		case registerAs = "register_as"
		case playerTypeID = "player_type_id"
		case playerType = "player_type"
		case ageGroupID = "age_group_id"
		case ageGroup = "age_group"
		case teamName = "team_name"
		case coachName = "coach_name"
		case coachIsdCode = "coach_isd_code"
		case coachMobileNumber = "coach_mobile_number"
		case coachEmailID = "coach_email_id"
		case cityID = "city_id"
		case cityName = "city_name"
		case stateID = "state_id"
		case stateName = "state_name"
		case countryID = "country_id"
		case countryName = "country_name"
		case remarks
		case subscriberAllowEdit = "subscriber_allow_edit"
		case players
		case allowReject = "allow_reject"
	}
}

struct PlayerSummary: Codable {
	var playerID, subscriberID, subscriberDisplayID: Int?
	var fullName: String?
	var genderID: Int?
	var gender, dob, isdCode: String?
	var mobileNumber: Int?
	var emailID: String?
	var positionID: Int?
	var position: String?
	
	enum CodingKeys: String, CodingKey {
		case playerID = "player_id"
		case subscriberID = "subscriber_id"
		case subscriberDisplayID = "subscriber_display_id"
		case fullName = "full_name"
		case genderID = "gender_id"
		case gender, dob
		case isdCode = "isd_code"
		case mobileNumber = "mobile_number"
		case emailID = "email_id"
		case positionID = "position_id"
		case position
	}
}

// MARK: - EventRegistrationResponse
struct EventRegistrationResponse: ResponseType {
	let status, msg, registrationID: String?
	let errors: [ResponseError]?
}

// MARK: - Error
struct ResponseError: Codable {
	let msg, param, location: String?
}
