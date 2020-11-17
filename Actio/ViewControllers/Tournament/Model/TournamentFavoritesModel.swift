//
//  TournamentFavoritesModel.swift
//  Actio
//
//  Created by senthil on 11/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

struct TournamentFavoritesModel: Codable {
    let id: Int?
    let tournamentName, venue, tournamentStartDate, tournamentStartMonth: String?
    let tournamentStartYear, tournamentStartRange, tournamentEndRange, tournamentLogo: String?
    let isRegistrationOpen: Int?
    
    var registrationStatus: TournamentListModel.Status {
        return TournamentListModel.Status(rawValue: isRegistrationOpen ?? 0) ?? .closed
    }

    enum CodingKeys: String, CodingKey {
        case id
        case tournamentName = "tournament_name"
        case venue
        case tournamentStartDate = "tournament_start_date"
        case tournamentStartMonth = "tournament_start_month"
        case tournamentStartYear = "tournament_start_year"
        case tournamentStartRange = "tournament_start_range"
        case tournamentEndRange = "tournament_end_range"
        case tournamentLogo = "tournament_logo"
        case isRegistrationOpen = "is_registration_open"
    }
}



