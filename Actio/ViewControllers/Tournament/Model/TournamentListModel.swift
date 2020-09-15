//
//  TournamentListModel.swift
//  Actio
//
//  Created by senthil on 11/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

struct TournamentListModel: Codable {
    let status : String?
    let favorites : [TournamentFavoritesModel]?
    let nearMe : [TournamentNearMeModel]?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case favorites = "Favorites"
        case nearMe = "nearMe"
    }
}

