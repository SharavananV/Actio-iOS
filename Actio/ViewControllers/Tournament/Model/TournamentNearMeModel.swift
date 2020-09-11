//
//  TournamentNearMeModel.swift
//  Actio
//
//  Created by senthil on 11/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

struct TournamentNearMeModel: Codable {
    
    let id : Int?
    let tournament_name : String?
    let tournament_venue : String?
    let tournament_start_date : String?
    let tournament_start_month : String?
    let tournament_start_year : String?
    let tournament_start_range : String?
    let tournament_end_range : String?
    let tournament_logo : String?
    let distance : Int?
    let is_registration_open : Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case tournament_name = "tournament_name"
        case tournament_venue = "tournament_venue"
        case tournament_start_date = "tournament_start_date"
        case tournament_start_month = "tournament_start_month"
        case tournament_start_year = "tournament_start_year"
        case tournament_start_range = "tournament_start_range"
        case tournament_end_range = "tournament_end_range"
        case tournament_logo = "tournament_logo"
        case distance = "distance"
        case is_registration_open = "is_registration_open"
    }
    
    internal init(id: Int, tournament_name: String, tournament_venue: String,tournament_start_date: String,tournament_start_month:String,tournament_start_year:String,tournament_start_range:String,tournament_end_range:String,tournament_logo:String,distance:Int,is_registration_open:Int) {
        self.id = id
        self.tournament_name = tournament_name
        self.tournament_venue = tournament_venue
        self.tournament_start_date = tournament_start_date
        self.tournament_start_month = tournament_start_month
        self.tournament_start_year = tournament_start_year
        self.tournament_start_range = tournament_start_range
        self.tournament_end_range = tournament_end_range
        self.tournament_logo = tournament_logo
        self.distance = distance
        self.is_registration_open = is_registration_open
        
    }
    
}


