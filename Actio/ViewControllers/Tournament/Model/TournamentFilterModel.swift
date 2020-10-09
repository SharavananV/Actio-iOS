//
//  TournamentFilterModel.swift
//  Actio
//
//  Created by apple on 09/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

struct TournamentFilterModel: Codable {
    let type, latitude, priceRangeStart, priceRangeEnd: String?
    let city: String?
    let radius, longitude, sport, category: String?

    enum CodingKeys: String, CodingKey {
        case type, latitude
        case priceRangeStart = "price_range_start"
        case priceRangeEnd = "price_range_end"
        case city, radius, longitude, sport, category
    }
}
