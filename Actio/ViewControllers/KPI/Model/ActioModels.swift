//
//  ActioModels.swift
//  Actio
//
//  Created by KnilaDev on 10/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - ActioKPIResponse
struct ActioKPIResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	var status: String?
	var event: KPIEvent?
}

// MARK: - KPIEvent
struct KPIEvent: Codable {
	var eventID: Int?
	var eventName: String?
	var sportsID: Int?
	var eventDateRange, eventStartDate, eventEndDate, sportsName: String?
	var tournamentID: Int?
	var tournamentName: String?
	var venueID: Int?
	var venueName: String?
	var kpi: [KpiFilterModel]?
	var coachList: [CoachList]?
	
	enum CodingKeys: String, CodingKey {
		case eventID = "event_id"
		case eventName = "event_name"
		case sportsID = "sports_id"
		case eventDateRange = "event_date_range"
		case eventStartDate = "event_start_date"
		case eventEndDate = "event_end_date"
		case sportsName = "sports_name"
		case tournamentID = "tournament_id"
		case tournamentName = "tournament_name"
		case venueID = "venue_id"
		case venueName = "venue_name"
		case kpi
		case coachList = "coach_list"
	}
}

// MARK: - CoachList
struct CoachList: Codable {
	var id: Int?
	var coachName: String?
}
