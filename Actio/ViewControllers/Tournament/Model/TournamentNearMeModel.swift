//
//  TournamentNearMeModel.swift
//  Actio
//
//  Created by senthil on 11/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

struct TournamentNearMeModel: Codable {
    let id: Int?
    let tournamentName, tournamentVenue, tournamentStartDate, tournamentStartMonth: String?
    let tournamentStartYear, tournamentStartRange, tournamentEndRange, tournamentLogo: String?
    let distance: Double?
    let isRegistrationOpen: Int?
    
    // 1 open , 2 close, 3 = yet to open
    var registrationStatus: TournamentListModel.Status {
        return TournamentListModel.Status(rawValue: isRegistrationOpen ?? 0) ?? .closed
    }

    enum CodingKeys: String, CodingKey {
        case id
        case tournamentName = "tournament_name"
        case tournamentVenue = "tournament_venue"
        case tournamentStartDate = "tournament_start_date"
        case tournamentStartMonth = "tournament_start_month"
        case tournamentStartYear = "tournament_start_year"
        case tournamentStartRange = "tournament_start_range"
        case tournamentEndRange = "tournament_end_range"
        case tournamentLogo = "tournament_logo"
        case distance
        case isRegistrationOpen = "is_registration_open"
    }
}


