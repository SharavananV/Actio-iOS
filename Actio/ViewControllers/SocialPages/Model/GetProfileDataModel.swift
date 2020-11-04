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
struct Coaching: Codable {
    let id, sportsID: Int?
    let sportsName: String?
    let cityID: Int?
    let cityName: String?
    let stateID: Int?
    let stateName, locality, remarks: String?

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
}

// MARK: - Institute
struct Institute: Codable {
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
struct Play: Codable {
    let id, sportsID: Int?
    let sportsName: String?
    let playingSince, weeklyHours: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case sportsID = "sports_id"
        case sportsName = "sports_name"
        case playingSince = "playing_since"
        case weeklyHours = "weekly_hours"
    }
}
