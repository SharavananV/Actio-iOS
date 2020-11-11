//
//  PerformanceReviewListModels.swift
//  Actio
//
//  Created by KnilaDev on 11/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

// MARK: - ReviewerListResponse
struct ReviewerListResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	var status: String?
	var list: [Reviewer]?
}

// MARK: - Reviewer
struct Reviewer: Codable {
	var id: Int?
	var name: String?
}

// MARK: - PerformanceReviewListResponse
struct PerformanceReviewListResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	var status: String?
	var list: ReviewEventList?
}

// MARK: - List
struct ReviewEventList: Codable {
	var actioEvents: [ActioEvent]?
	var nonActioEvents: [NonActioEvent]?
	
	enum CodingKeys: String, CodingKey {
		case actioEvents = "actio_events"
		case nonActioEvents = "non_actio_events"
	}
}

// MARK: - ActioEvent
struct ActioEvent: Codable {
	var eventID, kpiID: Int?
	var eventName, categoryName, type, eventAddress: String?
	var eventVenue, eventStartDate, eventEndDate, tournamentName: String?
	var status: Int?
	var eventCoachName: String?
	var eventKpiType: Int?
	var eventLogo: String?
	var eventKpi: [EventKpi]?
	
	var eventStatus: KpiStatus {
		return KpiStatus(rawValue: status ?? 0) ?? .approved
	}
	
	enum CodingKeys: String, CodingKey {
		case eventID = "event_id"
		case kpiID = "kpi_id"
		case eventName = "event_name"
		case categoryName = "category_name"
		case type
		case eventAddress = "event_address"
		case eventVenue = "event_venue"
		case eventStartDate = "event_start_date"
		case eventEndDate = "event_end_date"
		case tournamentName = "tournament_name"
		case status
		case eventCoachName = "event_coach_name"
		case eventKpiType = "event_kpi_type"
		case eventLogo = "event_logo"
		case eventKpi = "event_kpi"
	}
}

// MARK: - EventKpi
struct EventKpi: Codable {
	var kpiCategoryID: Int?
	var kpiCategoryName, kpiCategoryValue: String?
	var typeStatus: Int?
	
	enum CodingKeys: String, CodingKey {
		case kpiCategoryID = "kpi_category_id"
		case kpiCategoryName = "kpi_category_name"
		case kpiCategoryValue = "kpi_category_value"
		case typeStatus = "type_status"
	}
}

// MARK: - NonActioEvent
struct NonActioEvent: Codable {
	var eventID, kpiID: Int?
	var eventName, tournamentName, eventVenue, eventState: String?
	var eventCountry, eventCoachName, eventStartDate, eventEndDate: String?
	var eventYear: String?
	var status, eventKpiType: Int?
	var eventKpi: [EventKpi]?
	
	var eventStatus: KpiStatus {
		return KpiStatus(rawValue: status ?? 0) ?? .approved
	}
	
	enum CodingKeys: String, CodingKey {
		case eventID = "event_id"
		case kpiID = "kpi_id"
		case eventName = "event_name"
		case tournamentName = "tournament_name"
		case eventVenue = "event_venue"
		case eventState = "event_state"
		case eventCountry = "event_country"
		case eventCoachName = "event_coach_name"
		case eventStartDate = "event_start_date"
		case eventEndDate = "event_end_date"
		case eventYear = "event_year"
		case status
		case eventKpiType = "event_kpi_type"
		case eventKpi = "event_kpi"
	}
}

enum KpiStatus: Int {
	case pending = 1, drop = 2, revalidate = 3, approved
	
	var displayString: String {
		switch self {
		case .pending:
			return "Pending"
		case .drop:
			return "Drop"
		case .revalidate:
			return "Revalidate"
		case .approved:
			return "Approved"
		}
	}
	
	var statusColor: UIColor {
		switch self {
		case .pending:
			return #colorLiteral(red: 0.5569999814, green: 0.5569999814, blue: 0.5759999752, alpha: 1)
		case .drop:
			return #colorLiteral(red: 0.7803921569, green: 0, blue: 0.2235294118, alpha: 1)
		case .revalidate:
			return #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)
		case .approved:
			return #colorLiteral(red: 0, green: 0.7843137255, blue: 0.3254901961, alpha: 1)
		}
	}
}
