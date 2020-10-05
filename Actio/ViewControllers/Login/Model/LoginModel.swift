//
//  LoginModel.swift
//  Actio
//
//  Created by apple on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

struct LoginModelResponse: Codable {
    let status, msg, token: String?
    let subscriberSeqID: Int?
    let subscriberID, userStatus, fullName, userName: String?
    let emailID, isdCode, mobileNumber: String?
    let role: Int?
}
// MARK: - Welcome
struct ForgotUsernameResponse: Codable {
    let status: String?
    let result: ForgotUsernameModel?
}

// MARK: - Result
struct ForgotUsernameModel: Codable {
    let username, subscriberID: String?

    enum CodingKeys: String, CodingKey {
        case username
        case subscriberID = "subscriber_id"
    }
}
