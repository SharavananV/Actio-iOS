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
struct ProfileMaster: Codable {
    let country: [ProfileCountry]?
    let idTypes: [ProfileIDType]?
    let state: [ProfileState]?
    let city: [ String]?
    let sports: [Sport]?
    let institute: [ProfileInstitute]?
    let instituteClass, instituteStream, institutedivision: [String]?
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

