//
//  EventRegistrationModel.swift
//  Actio
//
//  Created by senthil on 01/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - EventsMasterResponse
struct EventsMasterResponse: ResponseType {
	var msg: String?
	let errors: [ActioError]?
	let status: String?
	let master: EventMaster?
}

// MARK: - Master
struct EventMaster: Codable {
	let registerBy: [RegisterBy]?
	let playerType, eventType: [EventTypeElement]?
	let ageGroup: [AgeGroup]?
	let country: [EventCountry]?
	let state: [State]?
	let city: [City]?
	let position: [Position]?
	let gender: [Gender]?
}

// MARK: - AgeGroup
struct AgeGroup: Codable {
	let id: Int?
	let groupName: String?
	let minAge, maxAge: Int?
	
	enum CodingKeys: String, CodingKey {
		case id
		case groupName = "group_name"
		case minAge = "min_age"
		case maxAge = "max_age"
	}
}

// MARK: - City
struct City: Codable {
	let id: Int?
	let city: String?
	let stateID: Int?
	
	enum CodingKeys: String, CodingKey {
		case id, city
		case stateID = "state_id"
	}
}

// MARK: - Country
struct EventCountry: Codable {
	let id: Int?
	let code, country, alias: String?
}

// MARK: - EventTypeElement
struct EventTypeElement: Codable {
	let id: Int?
	let type: String?
}

// MARK: - Gender
struct Gender: Codable {
	let id: Int?
	let gender: String?
}

// MARK: - Position
struct Position: Codable {
	let id: Int?
	let position: String?
	let sportsID: Int?
	
	enum CodingKeys: String, CodingKey {
		case id, position
		case sportsID = "sports_id"
	}
}

// MARK: - RegisterBy
struct RegisterBy: Codable {
	let id: Int?
	let registerBy: String?
	
	enum CodingKeys: String, CodingKey {
		case id
		case registerBy = "register_by"
	}
}

// MARK: - State
struct State: Codable {
	let id: Int?
	let state: String?
	let countryID: Int?
	let code: String?
	
	enum CodingKeys: String, CodingKey {
		case id, state
		case countryID = "country_id"
		case code
	}
}
