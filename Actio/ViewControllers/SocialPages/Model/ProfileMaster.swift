//
//  ProfileMaster.swift
//  Actio
//
//  Created by apple on 22/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

struct ProfileMasterResponse: ResponseType {
    var errors: [ActioError]?
    var msg: String?
    let status, logID: String?
    let master: ProfileMaster?
}

// MARK: - Master
class ProfileMaster: Codable {
    let country: [ProfileCountry]?
    let idTypes: [ProfileIDType]?
    let state: [ProfileState]?
    let stateCity: [StateCity]?
    let sports: [Sport]?
    let institute: [ProfileInstitute]?
    let instituteClass : [InstituteClass]?
    let instituteStream : [InstituteStream]?
    let institutedivision: [Institutedivision]?
}
// MARK: - InstituteClass
struct InstituteClass: Codable {
    let id: Int?
    let instituteClass: String?
    let instituteID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case instituteClass = "class"
        case instituteID = "institute_id"
    }
}

// MARK: - InstituteStream
struct InstituteStream: Codable {
    let id: Int?
    let stream: String?
    let classID: Int?

    enum CodingKeys: String, CodingKey {
        case id, stream
        case classID = "class_id"
    }
}
// MARK: - StateCity
struct StateCity: Codable {
    let stateID: Int?
    let stateName: String?
    let city: [ProfileCity]?

    enum CodingKeys: String, CodingKey {
        case stateID = "state_id"
        case stateName = "state_name"
        case city
    }
}

// MARK: - City
struct ProfileCity: Codable {
    let cityID: Int?
    let cityName: String?
    let stateID: Int?

    enum CodingKeys: String, CodingKey {
        case cityID = "city_id"
        case cityName = "city_name"
        case stateID = "state_id"
    }
}


// MARK: - Institutedivision
struct Institutedivision: Codable {
    let id: Int?
    let division: String?
    let streamID: Int?

    enum CodingKeys: String, CodingKey {
        case id, division
        case streamID = "stream_id"
    }
}

// MARK: - Country
class ProfileCountry: Codable {
    let id: Int?
    let code, country, alias: String?
}

// MARK: - IDType
struct ProfileIDType: Codable {
    let id: Int?
    let proof: String?
}

// MARK: - Institute
struct ProfileInstitute: Codable {
    let id: Int?
    let instituteName, address1, address2: String?

    enum CodingKeys: String, CodingKey {
        case id
        case instituteName = "institute_name"
        case address1, address2
    }
}

// MARK: - Sport
struct Sport: Codable {
    let id: Int?
    let sports: String?
}

// MARK: - State
struct ProfileState: Codable {
    let id: Int?
    let state: String?
    let countryID: Int?
    let code: String?

    enum CodingKeys: String, CodingKey {
        case id, state
        case countryID = "country_id"
        case code
    }
}
class ProfileRoleModel: Codable {
    
    internal init() {}
	
    var isStudent: Bool?
    var isCoach: Bool?
    var isSponser: Bool?
    var isOrganizer: Bool?
    var frontImage, backImage: Data?
    var sportsPlay : [Play]?
    var coaching : [Coaching]?
    var institute : Institute?
	var sponsorRemarks : String?
	var organizerRemarks : String?

    
    enum CodingKeys: String, CodingKey {
        
        case isStudent, isCoach, isSponser, isOrganizer,frontImage, backImage,sportsPlay,coaching,sponsorRemarks,organizerRemarks,institute

    }
    
    init(data: GetProfile?) {
        isStudent = data?.isStudent
        isCoach = data?.isCoach
        isSponser = data?.isSponsor
        isOrganizer = data?.isOrganizer
        sportsPlay = data?.play
        coaching = data?.coaching
        institute = data?.institute
		sponsorRemarks = data?.sponsorRemarks
		organizerRemarks = data?.organizerRemarks
		
    }
    
    func parameters() -> [String: Any] {
		let coachingValues = coaching?.map({ (coach) -> [String: Any] in
			return [
				"sportsID": coach.sportsID ?? 0,
				"cityID": coach.cityID ?? 0,
				"locality": coach.locality ?? "",
				"about": coach.remarks ?? ""
			]
		}) ?? []
		
		let playValues = sportsPlay?.map({ (play) -> [String: Any] in
			return [
				"sportsID": play.sportsID ?? 0,
				"since": play.playingSince ?? 0,
				"hours": play.weeklyHours ?? 0
			]
		}) ?? []
		
        return [
            CodingKeys.isStudent.rawValue : isStudent ?? false,
            CodingKeys.isCoach.rawValue : isCoach ?? false,
            CodingKeys.isOrganizer.rawValue : isOrganizer ?? false,
            CodingKeys.sportsPlay.rawValue : playValues,
			CodingKeys.coaching.rawValue : coachingValues,
			"isSponsor": isSponser ?? false,
			"instituteID" : institute?.instituteID ?? 0,
			"fromYear":institute?.academicFromYear ?? 0,
			"toYear":institute?.academicToYear ?? 0,
			"classID": institute?.classID ?? 0,
			"streamID": institute?.streamID ?? 0,
			"divisionID":institute?.divisionID ?? 0,
			"cityID": institute?.cityID ?? 0,
			"pincode":institute?.pincode ?? "",
			"aboutSponsorship": sponsorRemarks ?? "",
			"aboutOrganize": organizerRemarks ?? ""
        ]
    }
}

