//
//  EventScheduleModel.swift
//  Actio
//
//  Created by KnilaDev on 12/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - EventScheduleResponse
struct EventScheduleResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	var status, logID: String?
	var schedule: [EventSchedule]?
}

// MARK: - Schedule
class EventSchedule: Codable {
	var date, ddate: String?
	var match: [Match]?
	var isSelected: Bool = false
	
	enum CodingKeys: String, CodingKey {
		case date, ddate, match
	}
}

// MARK: - Match
struct Match: Codable {
	var iscustom: Bool?
	var scheduleID, eventID, matchTypeID: Int?
	var matchType, matchName, matchDescription, matchDate: String?
	var mdate, fromTime, from, toTime: String?
	var to: String?
	var eventName: String?
	var venueID: Int?
	var competitorID: Int?
	var competitor: String?
	var opponentID: Int?
	var opponent: String?
	var orderBy: Int?
	var venueName: String?
	var venueAssetID: Int?
	var venueAssetName, changeRemarks, actualStartDate, ast: String?
	var actualStartTime, actualEndTime, aet, competitorScore: String?
	var oponentScore, playground: String?
	var competitorRegisterBy, competitorCoach, opponentRegisterBy, opponentCoach: String?
	var competitorTeam, opponentTeam: [Team]?
	
	enum CodingKeys: String, CodingKey {
		case iscustom
		case scheduleID = "schedule_id"
		case eventID = "event_id"
		case matchTypeID = "match_type_id"
		case matchType = "match_type"
		case matchName = "match_name"
		case matchDescription = "description"
		case matchDate = "match_date"
		case fromTime = "from_time"
		case from, to, mdate
		case toTime = "to_time"
		case competitorID = "competitor_id"
		case competitor
		case opponentID = "opponent_id"
		case opponent
		case orderBy = "order_by"
		case venueName = "venue_name"
		case venueAssetID = "venue_asset_id"
		case venueAssetName = "venue_asset_name"
		case changeRemarks = "change_remarks"
		case actualStartDate = "actual_start_date"
		case ast
		case actualStartTime = "actual_start_time"
		case actualEndTime = "actual_end_time"
		case aet
		case competitorScore = "competitor_score"
		case oponentScore = "oponent_score"
		case playground
		case eventName = "event_name"
		case venueID = "venue_id"
		case competitorRegisterBy = "competitor_register_by"
		case competitorCoach = "competitor_coach"
		case opponentRegisterBy = "opponent_register_by"
		case opponentCoach = "opponent_coach"
		case competitorTeam = "competitor_team"
		case opponentTeam = "opponent_team"
	}
}

// MARK: - EventScheduleDetailResponse
struct EventScheduleDetailResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	var status, logID: String?
	var match: Match?
}

// MARK: - Team
struct Team: Codable {
	var playerID, subscriberID: Int?
	var fullName: String?
	
	enum CodingKeys: String, CodingKey {
		case playerID = "player_id"
		case subscriberID = "subscriber_id"
		case fullName = "full_name"
	}
}
