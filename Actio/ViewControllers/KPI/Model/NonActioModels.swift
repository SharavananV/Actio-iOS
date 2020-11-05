//
//  NonActioModels.swift
//  Actio
//
//  Created by KnilaDev on 04/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - NonActioMasterResponse
struct NonActioMasterResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	var status: String?
	
	var result: NonActioMaster?
}

// MARK: - NonActioMaster
struct NonActioMaster: Codable {
	var countryState: [CountryState]?
	var sports: [TournamentSport]?
	var years: [Int]?
	var tournaments: [TournamentKPI]?
	var events: [Event]?
	var kpi: [KpiFilterModel]?
}

// MARK: - CountryState
struct CountryState: Codable {
	var countryID: Int?
	var countryName: String?
	var states: [KPIState]?
	
	enum CodingKeys: String, CodingKey {
		case countryID = "country_id"
		case countryName = "country_name"
		case states
	}
}

// MARK: - State
struct KPIState: Codable {
	var stateID: Int?
	var stateName: String?
	var countryID: Int?
	
	enum CodingKeys: String, CodingKey {
		case stateID = "state_id"
		case stateName = "state_name"
		case countryID = "country_id"
	}
}

// MARK: - RegisterNonActioSportModel
class RegisterNonActioSportModel {
	var eventID, tournamentID, coachID: Int?
	var kpi = [String: String]()
	var kpiText = [String: String]()
	
	// Only client side use
	var country: Int?
	var state: Int?
	var year: Int?
	var coachName: String?
	
	init() {}
	
	func parameters() -> [String: Any] {
		let kpiValues = kpi.map { (pair) -> [String: Any] in
			return ["id": pair.key, "value": pair.value]
		}
		return [
			"eventID": eventID ?? "",
			"tournamentID": tournamentID ?? "",
			"coachID": coachID ?? "",
			"kpi": kpiValues
		]
	}
	
	func validate() -> ValidType {
		if Validator.isValidRequiredField(self.eventID) != .valid {
			return .invalid(message: "Select Event")
		}
		if Validator.isValidRequiredField(self.tournamentID) != .valid {
			return .invalid(message: "Select Tournament")
		}
		if Validator.isValidRequiredField(self.coachID) != .valid {
			return .invalid(message: "Select a coach")
		}
		if Validator.isValidRequiredField(self.country) != .valid {
			return .invalid(message: "Select Country")
		}
		if Validator.isValidRequiredField(self.state) != .valid {
			return .invalid(message: "Select State")
		}
		if Validator.isValidRequiredField(self.year) != .valid {
			return .invalid(message: "Select Year")
		}
		
		for (key, value) in kpi {
			if Validator.isValidRequiredField(value) != .valid {
				return .invalid(message: "\(kpiText[key] ?? "") is empty")
			}
		}
		
		return .valid
	}
}

// MARK: - NonActioFilterResponse
struct NonActioFilterResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	var status: String?
	var result: NonActioFilter?
}

// MARK: - Result
struct NonActioFilter: Codable {
	var years: [Int]?
	var tournaments: [TournamentKPI]?
	var events: [Event]?
	var kpi: [KpiFilterModel]?
}

// MARK: - Kpi
struct KpiFilterModel: Codable {
	var kpiID: Int?
	var kpiName: String?
	var kpiType: Int?
	
	enum CodingKeys: String, CodingKey {
		case kpiID = "kpi_id"
		case kpiName = "kpi_name"
		case kpiType = "kpi_type"
	}
}

// MARK: - Tournament
struct TournamentKPI: Codable {
	var tournamentID: Int?
	var tournamentName: String?
	
	enum CodingKeys: String, CodingKey {
		case tournamentID = "tournament_id"
		case tournamentName = "tournament_name"
	}
}
