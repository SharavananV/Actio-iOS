//
//  MasterModel.swift
//  Actio
//
//  Created by apple on 08/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct TournamentMasterResponse: ResponseType {
    var errors: [ActioError]?
    let status, msg: String?
    let result: TournamentMaster?
}

// MARK: - Result
struct TournamentMaster: Codable {
    let city: [TournamentCity]?
    let state: [TournamentState]?
    let country: [TournamentCountry]?
    let tournamentType: [TournamentType]?
    let sportsCategory: [SportsCategory]?
    let sports: [TournamentSport]?

    enum CodingKeys: String, CodingKey {
        case city, state, country
        case tournamentType = "tournament_type"
        case sportsCategory = "sports_category"
        case sports
    }
}

// MARK: - City
struct TournamentCity: Codable {
    let id, stateID: Int?
    let cityName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case stateID = "state_id"
        case cityName = "city_name"
    }
}

// MARK: - Country
struct TournamentCountry: Codable {
    let id: Int?
    let code, name, alias, minAge: String?

    enum CodingKeys: String, CodingKey {
        case id, code, name, alias
        case minAge = "min_age"
    }
}

// MARK: - Sport
struct TournamentSport: Codable {
    let id: Int?
    let sportsName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case sportsName = "sports_name"
    }
}

// MARK: - SportsCategory
struct SportsCategory: Codable {
    let id, sportsID: Int?
    let categoryName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case sportsID = "sports_id"
        case categoryName = "category_name"
    }
}

// MARK: - State
struct TournamentState: Codable {
    let id, countryID: Int?
    let stateName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case stateName = "state_name"
    }
}

// MARK: - TournamentType
struct TournamentType: Codable {
    let id: Int?
    let name: String?
}
