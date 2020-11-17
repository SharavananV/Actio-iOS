//
//  GetProfileDataModel.swift
//  Actio
//
//  Created by apple on 22/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
// MARK: - GetProfileDataResponse
struct GetProfileDataResponse: ResponseType {
    var errors: [ActioError]?
    var msg: String?
    let status, logID: String?
    let profile: GetProfile?
}

// MARK: - Profile
struct GetProfile: Codable {
    let subscriberID: Int?
    let subscriberDisplayID: String?
    let isStudent: Bool?
    let institute: Institute?
    let play: [Play]?
    let isCoach: Bool?
    let coaching : [Coaching]?
    let isSponsor: Bool?
    let sponsorRemarks: String?
    let isOrganizer: Bool?
    let organizerRemarks, profileImage: String?

    enum CodingKeys: String, CodingKey {
        case subscriberID = "subscriber_id"
        case subscriberDisplayID = "subscriber_display_id"
        case isStudent = "is_student"
        case institute, play
        case isCoach = "is_coach"
        case coaching
        case isSponsor = "is_sponsor"
        case sponsorRemarks = "sponsor_remarks"
        case isOrganizer = "is_organizer"
        case organizerRemarks = "organizer_remarks"
        case profileImage = "profile_image"
    }
}


// MARK: - Coaching
class Coaching: Codable {
	internal init() {
		self.id = nil
		self.sportsID = nil
		self.sportsName = nil
		self.cityID = nil
		self.cityName = nil
		self.stateID = nil
		self.stateName = nil
		self.locality = nil
		self.remarks = nil
	}
	
    var id, sportsID: Int?
    var sportsName: String?
	var cityID: Int?
	var cityName: String?
	var stateID: Int?
	var stateName, locality, remarks: String?

    enum CodingKeys: String, CodingKey {
        case id
        case sportsID = "sports_id"
        case sportsName = "sports_name"
        case cityID = "city_id"
        case cityName = "city_name"
        case stateID = "state_id"
        case stateName = "state_name"
        case locality, remarks
    }
	
	func validate() -> ValidType {
		if Validator.isValidRequiredField(self.sportsID) != .valid {
			return .invalid(message: "Select Sport")
		}
		if Validator.isValidRequiredField(self.stateID) != .valid {
			return .invalid(message: "Select State")
		}
		if Validator.isValidRequiredField(self.cityID) != .valid {
			return .invalid(message: "Select City")
		}
		if Validator.isValidRequiredField(self.locality) != .valid {
			return .invalid(message: "Enter Locality")
		}
		if Validator.isValidRequiredField(self.remarks) != .valid {
			return .invalid(message: "Enter About Coach")
		}
		
		return .valid
	}
}

// MARK: - Institute
class Institute: Codable {
    var instituteID: Int?
	var instituteName: String?
    var classID: Int?
	var instituteClass: String?
	var streamID: Int?
	var stream: String?
	var divisionID: Int?
	var division: String?
	var countryID: Int?
	var country: String?
    var stateID: Int?
	var stateName: String?
	var cityID: Int?
	var cityName: String?
	var academicFromYear, academicToYear, pincode: Int?
	
	func validate() -> ValidType {
		if Validator.isValidRequiredField(self.instituteID) != .valid {
			return .invalid(message: "Select Institution")
		}
		if Validator.isValidRequiredField(self.academicFromYear) != .valid {
			return .invalid(message: "Enter From Academic Year")
		}
		if Validator.isValidYear(self.academicFromYear) != .valid {
			return .invalid(message: "Enter Valid Academic Year")
		}
		if Validator.isValidRequiredField(self.academicToYear) != .valid {
			return .invalid(message: "Enter To Academic Year")
		}
		if Validator.checkIfFromGreaterThanToYear(self.academicFromYear, toYear: self.academicToYear) != .valid {
			return .invalid(message: "Academic year must be greater than from year")
		}
		if Validator.isValidRequiredField(self.classID) != .valid {
			return .invalid(message: "Select Class")
		}
		if Validator.isValidRequiredField(self.streamID) != .valid {
			return .invalid(message: "Select Stream")
		}
		if Validator.isValidRequiredField(self.divisionID) != .valid {
			return .invalid(message: "Select Division")
		}
		if Validator.isValidRequiredField(self.countryID) != .valid {
			return .invalid(message: "Select Country")
		}
		if Validator.isValidRequiredField(self.stateID) != .valid {
			return .invalid(message: "Select State")
		}
		if Validator.isValidRequiredField(self.cityID) != .valid {
			return .invalid(message: "Select City")
		}
		if Validator.isValidRequiredField(self.pincode) != .valid {
			return .invalid(message: "Enter Postal Code")
		}
		if Validator.isValidPostalCode(self.pincode) != .valid {
			return .invalid(message: "Enter Valid Postal Code")
		}
		
		return .valid
	}
	
	internal init() {}

    enum CodingKeys: String, CodingKey {
        case instituteID = "institute_id"
        case instituteName = "institute_name"
        case classID = "class_id"
        case instituteClass = "class"
        case streamID = "stream_id"
        case stream
        case divisionID = "division_id"
        case division
        case countryID = "country_id"
        case country
        case stateID = "state_id"
        case stateName = "state_name"
        case cityID = "city_id"
        case cityName = "city_name"
        case academicFromYear = "academic_from_year"
        case academicToYear = "academic_to_year"
        case pincode
    }
}

// MARK: - Play
class Play: Codable {
    var id, sportsID: Int?
    var sportsName: String?
    var playingSince, weeklyHours: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case sportsID = "sports_id"
        case sportsName = "sports_name"
        case playingSince = "playing_since"
        case weeklyHours = "weekly_hours"
    }
	
	func validate() -> ValidType {
		if Validator.isValidRequiredField(self.sportsName) != .valid {
			return .invalid(message: "Select Sport")
		}
		if Validator.isValidRequiredField(self.playingSince) != .valid {
			return .invalid(message: "Enter Player Since")
		}
		if Validator.isValidYear(self.playingSince) != .valid {
			return .invalid(message: "Enter Valid Player Since")
		}
		if Validator.isValidPastYear(self.playingSince) != .valid {
			return .invalid(message: "Entered Player Since should not be greater than current year")
		}
		if Validator.isValidRequiredField(self.weeklyHours) != .valid {
			return .invalid(message: "Enter Weekly Practice Hrs")
		}
		if Validator.isValidWeeklyHours(self.weeklyHours) != .valid {
			return .invalid(message: "Invalid Practice Hrs")
		}
		
		return .valid
	}
}
