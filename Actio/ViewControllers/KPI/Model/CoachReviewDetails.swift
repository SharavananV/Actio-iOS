//
//  CoachReviewDetails.swift
//  Actio
//
//  Created by KnilaDev on 11/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - CoachReviewDetailsResponse
struct CoachReviewDetailsResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	var status: String?
	var result: CoachReviewDetails?
}

// MARK: - Result
struct CoachReviewDetails: Codable {
	var kpiID: Int?
	var eventName, eventVenue, eventPlayerName, eventStartDate: String?
	var eventEndDate, tournamentName: String?
	var eventKpi: [EventKpi]?
	
	enum CodingKeys: String, CodingKey {
		case kpiID = "kpi_id"
		case eventName = "event_name"
		case eventVenue = "event_venue"
		case eventPlayerName = "event_player_name"
		case eventStartDate = "event_start_date"
		case eventEndDate = "event_end_date"
		case tournamentName = "tournament_name"
		case eventKpi = "event_kpi"
	}
}
