//
//  EventRegistrationModel.swift
//  Actio
//
//  Created by senthil on 01/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - EventDetailsRegisterModel
class EventDetailsRegisterModel: Codable {
	internal init() {
		self.eventID = nil
		self.registerBy = nil
		self.teamName = nil
		self.ageGroup = nil
		self.cityID = nil
		self.isCoach = nil
		self.coachName = nil
		self.coachIsd = nil
		self.coachMobile = nil
		self.coachEmail = nil
		self.registrationID = nil
	}
	
	var eventID, registerBy, teamName, ageGroup: String?
	var cityID: String?
	var isCoach: Bool?
	var coachName, coachIsd, coachMobile, coachEmail: String?
	var registrationID: String?
	
	enum CodingKeys: String, CodingKey {
		case eventID, registerBy, teamName, ageGroup, cityID, isCoach, coachName, coachIsd, coachMobile, coachEmail, registrationID
	}
	
	func parameters() -> [String: Any] {
		return [
			CodingKeys.eventID.rawValue: eventID ?? "",
			CodingKeys.registerBy.rawValue: registerBy ?? "",
			CodingKeys.teamName.rawValue: teamName ?? "",
			CodingKeys.ageGroup.rawValue: ageGroup ?? "",
			CodingKeys.cityID.rawValue: cityID ?? "",
			CodingKeys.isCoach.rawValue: isCoach ?? "false",
			CodingKeys.coachName.rawValue: coachName ?? "",
			CodingKeys.coachIsd.rawValue: coachIsd ?? "",
			CodingKeys.coachMobile.rawValue: coachMobile ?? "",
			CodingKeys.coachEmail.rawValue: coachEmail ?? "",
			CodingKeys.registrationID.rawValue: registrationID ?? ""
		]
	}
}
