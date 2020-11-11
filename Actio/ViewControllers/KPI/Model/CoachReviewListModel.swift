//
//  CoachReviewListModel.swift
//  Actio
//
//  Created by KnilaDev on 11/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - PerformanceCoachReviewListResponse
struct PerformanceCoachReviewListResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	var status: String?
	var result: PerformanceCoachReviewList?
}

// MARK: - PerformanceCoachReviewList
struct PerformanceCoachReviewList: Codable {
	var eventName: String?
	var list: [PlayerKPIDetail]?
	
	enum CodingKeys: String, CodingKey {
		case eventName = "event_name"
		case list
	}
}

// MARK: - PlayerKPIDetail
struct PlayerKPIDetail: Codable {
	var kpiID: Int?
	var eventName: String?
	var playerSubscriberID: Int?
	var playerName, profileImage: String?
	var statusString: Int?
	
	enum CodingKeys: String, CodingKey {
		case kpiID = "kpi_id"
		case eventName = "event_name"
		case playerSubscriberID = "player_subscriber_id"
		case playerName = "player_name"
		case profileImage = "profile_image"
		case statusString = "status_string"
	}
	
	var eventStatus: KpiStatus {
		return PlayerKPIDetail.KpiStatus(rawValue: statusString ?? 0) ?? .waiting
	}
	
	enum KpiStatus: Int {
		case waiting = 1, drop = 2, revalidate = 3, approved
		
		var displayString: String {
			switch self {
			case .waiting:
				return "Waiting for validate"
			case .drop:
				return "Dropped"
			case .revalidate:
				return "Revalidate"
			case .approved:
				return "Approved"
			}
		}
		
		var statusImage: String? {
			switch self {
			case .waiting:
				return "waiting"
			case .drop:
				return "drop"
			case .revalidate:
				return "revalidate"
			case .approved:
				return "approved"
			}
		}
	}
}
