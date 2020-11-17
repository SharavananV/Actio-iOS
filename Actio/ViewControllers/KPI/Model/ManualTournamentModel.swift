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
	
	func validate() -> ValidType {
		if Validator.isValidRequiredField(self.country) != .valid {
			return .invalid(message: "Select Country")
		}
		if Validator.isValidRequiredField(self.state) != .valid {
			return .invalid(message: "Select State")
		}
		if Validator.isValidRequiredField(self.year) != .valid {
			return .invalid(message: "Select Year")
		}
		if Validator.isValidRequiredField(self.tournamentName ?? "") != .valid {
			return .invalid(message: "Enter Tournament Name")
		}
		if Validator.isValidRequiredField(self.fromDate ?? "") != .valid {
			return .invalid(message: "Select From Date")
		}
		if Validator.isValidRequiredField(self.toDate ?? "") != .valid {
			return .invalid(message: "Select To Date")
		}
		if Validator.isValidRequiredField(self.venue ?? "") != .valid {
			return .invalid(message: "Enter Venue")
		}
		
		for event in (events ?? []) {
			if Validator.isValidRequiredField(event.name ?? "") != .valid {
				return .invalid(message: "Enter Event value")
			}
			if Validator.isValidRequiredField(event.sports) != .valid {
				return .invalid(message: "Enter Sport")
			}
		}
		
		return .valid
	}
}
