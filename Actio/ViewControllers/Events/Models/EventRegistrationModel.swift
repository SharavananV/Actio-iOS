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
	
	let eventID, registerBy, teamName, ageGroup: String?
	let cityID: String?
	let isCoach: Bool?
	let coachName, coachIsd, coachMobile, coachEmail: String?
	let registrationID: String?
}
