//
//  ManualTournamentModel.swift
//  Actio
//
//  Created by KnilaDev on 06/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - RegisterNewTournamentModel
struct RegisterNewTournamentModel {
	var country, state, year: Int?
	var tournamentName, fromDate, toDate, venue: String?
	var events: [AddEventDetailsModel]? = [AddEventDetailsModel]()
	
	enum CodingKeys: String, CodingKey {
		case country, state
		case tournamentName = "tournament_name"
		case fromDate = "from_date"
		case toDate = "to_date"
		case venue, event
	}
	
	func parameters() -> [String: Any] {
		let allEvents = events?.map({ (model) -> [String : Any] in
			[
				"sports": model.sports ?? "",
				"name": model.name ?? ""
			]
		})
		
		return [
			"country": country ?? "",
			"state": state ?? "",
			"tournament_name": tournamentName ?? "",
			"from_date": fromDate ?? "",
			"to_date": toDate ?? "",
			"venue": venue ?? "",
			"event": allEvents ?? []
		]
	}
}
