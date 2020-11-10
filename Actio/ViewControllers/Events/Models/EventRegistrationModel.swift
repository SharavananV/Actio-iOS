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
	
	internal init() {}
	
	var eventID, registerBy, teamName, ageGroup: String?
	var countryID, stateID, cityID: String?
	var isCoach: Bool?
	var coachId: Int?
	var coachName, coachIsd, coachMobile, coachEmail: String?
	var registrationID: String?
	
	enum CodingKeys: String, CodingKey {
		case eventID, registerBy, teamName, ageGroup, cityID, isCoach, coachName, coachIsd, coachMobile, coachEmail, registrationID, countryID, stateID
		case coachId = "coach_SubscribeId"
	}
	
	func parameters() -> [String: Any] {
		return [
			CodingKeys.eventID.rawValue: eventID ?? "",
			CodingKeys.registerBy.rawValue: registerBy ?? "",
			CodingKeys.teamName.rawValue: teamName ?? "",
			CodingKeys.ageGroup.rawValue: ageGroup ?? "",
			CodingKeys.cityID.rawValue: cityID ?? "",
			CodingKeys.coachName.rawValue: coachName ?? "",
			CodingKeys.coachIsd.rawValue: coachIsd ?? "",
			CodingKeys.coachMobile.rawValue: coachMobile ?? "",
			CodingKeys.coachEmail.rawValue: coachEmail ?? "",
			CodingKeys.registrationID.rawValue: registrationID ?? "",
			CodingKeys.coachId.rawValue: String(coachId ?? 0)
		]
	}
	
	init(_ model: ViewStatus?) {
		self.eventID = String(model?.eventID ?? 0)
		self.registerBy = String(model?.registerByID ?? 0)
		self.teamName = model?.teamName
		self.ageGroup = String(model?.ageGroupID ?? 0)
		self.countryID = String(model?.countryID ?? 0)
		self.stateID = String(model?.stateID ?? 0)
		self.cityID = String(model?.cityID ?? 0)
		self.isCoach = model?.coachName?.count ?? 0 > 0
		self.coachName = model?.coachName
		self.coachIsd = model?.coachIsdCode
		self.coachMobile = model?.coachMobileNumber
		self.coachEmail = model?.coachEmailID
		self.registrationID = String(model?.registrationID ?? 0)
		self.coachId = model?.coachId
	}
	
	func validate() -> ValidType {
		if Validator.isValidRequiredField(self.registerBy ?? "") != .valid {
			return .invalid(message: "Select Registration By")
		}
		if Validator.isValidRequiredField(self.ageGroup ?? "") != .valid {
			return .invalid(message: "Select Age Group")
		}
		if Validator.isValidRequiredField(self.teamName ?? "") != .valid {
			return .invalid(message: "Enter Team Name")
		}
		if Validator.isValidRequiredField(self.countryID ?? "") != .valid {
			return .invalid(message: "Select Country")
		}
		if Validator.isValidRequiredField(self.stateID ?? "") != .valid {
			return .invalid(message: "Select State")
		}
		if Validator.isValidRequiredField(self.cityID ?? "") != .valid {
			return .invalid(message: "Select City")
		}
		
		if isCoach == true {
			if Validator.isValidRequiredField(self.coachName ?? "") != .valid {
				return .invalid(message: "Enter Coach Name")
			}
			if Validator.isValidRequiredField(self.coachIsd ?? "") != .valid {
				return .invalid(message: "Select Country Code")
			}
			if Validator.isValidRequiredField(self.coachMobile ?? "") != .valid {
				return .invalid(message: "Enter Coach Mobile No")
			}
			if Validator.isValidEmail(self.coachEmail ?? "") != .valid {
				return .invalid(message: "Enter Valid Coach Email ID")
			}
		}
		
		return .valid
	}
}
