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
struct RegisterNonActioSportModel {
	var eventID, tournamentID, coachID: Int
	var kpi: [Kpi]
	
	// Only client side use
	var country: Int
	var state: Int
	var year: Int
}

// MARK: - Kpi
struct Kpi {
	var id, value: String
}
