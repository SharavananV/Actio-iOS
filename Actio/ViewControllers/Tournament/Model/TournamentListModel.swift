//
//  TournamentListModel.swift
//  Actio
//
//  Created by senthil on 11/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import UIKit

class TournamentResponse: Codable {
    let status : String
    let list: TournamentListModel
}

class TournamentListModel: Codable {
    let favorites: [TournamentFavoritesModel]
    let nearMe: [TournamentNearMeModel]
    
    enum Status: Int {
        case open = 1, closed = 2, yetToOpen = 3
        
        var displayString: String {
            switch self {
            case .open:
                return "Registration open"
            case .closed:
                return "Registration closed"
            case .yetToOpen:
                return "Registration to be open"
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .open:
                return #colorLiteral(red: 0, green: 0.7843137255, blue: 0.3254901961, alpha: 1)
            case .closed:
                return #colorLiteral(red: 0.7803921569, green: 0, blue: 0.2235294118, alpha: 1)
            case .yetToOpen:
                return #colorLiteral(red: 1, green: 0.537254902, blue: 0.2392156863, alpha: 1)
            }
        }
    }
}

