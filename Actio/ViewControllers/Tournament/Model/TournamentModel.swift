//
//  TournamentModel.swift
//  Actio
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

struct TournamentResponse: Codable {
    let status : String
    let tournament: Tournament
}

// MARK: - Tournament
struct Tournament: Codable {
    let id: Int
    let tournamentName, tournamentDescription, tournamentType, tournamentVenue: String
    let tournamentAddress: String
    let tournamentLat, tournamentLong: Double
    let registrationEndDateRange, tournamentLogo: String
    let tournamentBanner: [String]
    let sponsers, affliations: [TournamentAffliation]
    let feeType, eBEDateRange, tournamentDate: String
    let directorsOrganizers: [SubscriberList]
    let entryFees, earlyBirdEntryFees: String

    enum CodingKeys: String, CodingKey {
        case id
        case tournamentName = "tournament_name"
        case tournamentDescription = "tournament_description"
        case tournamentType = "tournament_type"
        case tournamentVenue = "tournament_venue"
        case tournamentAddress = "tournament_address"
        case tournamentLat = "tournament_lat"
        case tournamentLong = "tournament_long"
        case registrationEndDateRange = "tournament_registration_end_date_range"
        case tournamentLogo = "tournament_logo"
        case tournamentBanner = "tournament_banner"
        case sponsers = "tournament_sponsers"
        case affliations = "tournament_affliations"
        case feeType = "tournament_fee_type"
        case eBEDateRange = "tournament_early_bird_end_date_range"
        case tournamentDate = "tournament_date"
        case directorsOrganizers = "tournament_directors_organizers"
        case entryFees = "tournament_entry_fees"
        case earlyBirdEntryFees = "early_bird_entry_fees"
    }
}

// MARK: - TournamentAffliationElement
struct TournamentAffliation: Codable {
    let name, logo: String
}

// MARK: - TournamentDirectorsOrganizer
struct SubscriberList: Codable {
    let name: String
    let items: [Subscriber]
}

// MARK: - Item
struct Subscriber: Codable {
    let subscriberID, username, emailID, mobileNumber: String

    enum CodingKeys: String, CodingKey {
        case subscriberID = "subscriber_id"
        case username
        case emailID = "email_id"
        case mobileNumber = "mobile_number"
    }
}
