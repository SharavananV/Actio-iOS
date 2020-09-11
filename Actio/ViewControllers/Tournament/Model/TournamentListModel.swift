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
    let Favorites : [TournamentFavoritesModel]?
    let nearMe : [TournamentNearMeModel]?

    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case Favorites = "Favorites"
        case nearMe = "nearMe"
    }
    
    internal init(status: String,Favorites: [TournamentFavoritesModel],nearMe:[TournamentNearMeModel]) {
        self.status = status
        self.Favorites = Favorites
        self.nearMe = nearMe
        
    }
    
}

